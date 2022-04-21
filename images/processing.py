#!/usr/bin/python3
from PIL import Image
import numpy as np
import sys

def encode(image):
    structured_data = np.asarray(Image.open(image)).flatten().tolist()
    raw_data = "".join(list(map(lambda byte: format(byte, '02x'), structured_data)))

    with open(f"{image}.hex", 'w') as f:
        f.write(raw_data)

def decode(file):
    with open(file) as dump:
        data = bytes.fromhex(dump.read().strip())
        image = Image.frombuffer("RGB", (640, 480), data, "raw", "RGB", 0, 1)
        image.save(f"{file}.png", "PNG")

def main():
    files = sys.argv[1:]

    if len(files) == 0:
        print(f"Usage: {sys.argv[0]} <space-separated list of paths to files>")
        return

    for file in files:
        if file.endswith('png'):
            encode(file)
        elif file.endswith('hex'):
            decode(file)

if __name__ == '__main__':
    main()