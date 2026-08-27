#!/usr/bin/env python3
"""Writes a copy of an Xcursor theme with every frame scaled up by an integer factor.

Nearest-neighbour, so pixel art stays sharp. Hyprland renders its own cursor at
half size when any monitor is fractionally scaled; a 2x theme cancels that out.

  upscale-cursors.py <src-theme-dir> <dst-theme-dir> [factor]
"""
import os
import shutil
import struct
import sys

IMAGE_TYPE = 0xfffd0002
CHUNK_HEADER = 36


def read_images(path):
    blob = open(path, 'rb').read()
    if blob[:4] != b'Xcur':
        return None
    _, _, ntoc = struct.unpack('<III', blob[4:16])
    images = []
    for i in range(ntoc):
        kind, subtype, pos = struct.unpack('<III', blob[16 + 12 * i:28 + 12 * i])
        if kind != IMAGE_TYPE:
            continue
        _, _, _, _, w, h, xhot, yhot, delay = struct.unpack('<IIIIIIIII', blob[pos:pos + CHUNK_HEADER])
        pixels = blob[pos + CHUNK_HEADER:pos + CHUNK_HEADER + w * h * 4]
        images.append(dict(nominal=subtype, w=w, h=h, xhot=xhot, yhot=yhot, delay=delay, pixels=pixels))
    return images


def scale_nearest(image, factor):
    w, h, src = image['w'], image['h'], image['pixels']
    nw, nh = w * factor, h * factor
    out = bytearray(nw * nh * 4)
    for y in range(nh):
        src_row = (y // factor) * w * 4
        dst_row = y * nw * 4
        for x in range(nw):
            s = src_row + (x // factor) * 4
            d = dst_row + x * 4
            out[d:d + 4] = src[s:s + 4]
    return dict(nominal=image['nominal'] * factor, w=nw, h=nh,
                xhot=image['xhot'] * factor, yhot=image['yhot'] * factor,
                delay=image['delay'], pixels=bytes(out))


def write_images(path, images):
    images = sorted(images, key=lambda i: i['nominal'])
    offset = 16 + 12 * len(images)
    positions = []
    for image in images:
        positions.append(offset)
        offset += CHUNK_HEADER + len(image['pixels'])
    out = bytearray(b'Xcur' + struct.pack('<III', 16, 0x10000, len(images)))
    for image, pos in zip(images, positions):
        out += struct.pack('<III', IMAGE_TYPE, image['nominal'], pos)
    for image in images:
        out += struct.pack('<IIIIIIIII', CHUNK_HEADER, IMAGE_TYPE, image['nominal'], 1,
                           image['w'], image['h'], image['xhot'], image['yhot'], image['delay'])
        out += image['pixels']
    open(path, 'wb').write(bytes(out))


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    src, dst = sys.argv[1].rstrip('/'), sys.argv[2].rstrip('/')
    factor = int(sys.argv[3]) if len(sys.argv) > 3 else 2
    name = os.path.basename(dst)

    shutil.rmtree(dst, ignore_errors=True)
    os.makedirs(os.path.join(dst, 'cursors'))
    with open(os.path.join(dst, 'index.theme'), 'w') as f:
        f.write(f"[Icon Theme]\nName={name}\nComment=Project Sekai cursors, {factor}x\n")

    src_cursors, dst_cursors = os.path.join(src, 'cursors'), os.path.join(dst, 'cursors')
    scaled = links = 0
    for entry in sorted(os.listdir(src_cursors)):
        src_path = os.path.join(src_cursors, entry)
        if os.path.islink(src_path):
            os.symlink(os.readlink(src_path), os.path.join(dst_cursors, entry))
            links += 1
            continue
        images = read_images(src_path)
        if images is None:
            continue
        write_images(os.path.join(dst_cursors, entry), [scale_nearest(i, factor) for i in images])
        scaled += 1
    print(f"{name}: scaled {scaled} cursors by {factor}x, {links} name aliases")


main()
