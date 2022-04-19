from PIL import Image
import numpy as np

images = ['photo0.png', 'photo1.png', 'photo2.png']

for image in images:
    structured_data = np.asarray(Image.open(image)).flatten().tolist()
    raw_data = list(map(lambda byte: format(byte, 'x'), structured_data))

    with open(f"{image}.hex", 'w') as f:
        for x in raw_data:
            f.write(x + '\n')