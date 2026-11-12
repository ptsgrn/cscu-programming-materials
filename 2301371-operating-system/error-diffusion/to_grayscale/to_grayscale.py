from PIL import Image
import numpy as np
import sys


def to_grayscale(image_path, output_path):

    # load image
    img = Image.open(image_path)

    # convert to grayscale
    grayscale_img = img.convert('L')

    # save the grayscale image
    grayscale_img.save(output_path)
    print(f"Grayscale image saved to {output_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python to_grayscale.py <input_image_path> <output_image_path>")
        sys.exit(1)

    input_image_path = sys.argv[1]
    output_image_path = sys.argv[2]

    to_grayscale(input_image_path, output_image_path)
