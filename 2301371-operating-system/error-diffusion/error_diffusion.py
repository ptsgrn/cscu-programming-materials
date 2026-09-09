import numpy as np
import math
import sys
from PIL import Image
from matplotlib import pyplot as plt

def seq_error_diffusion(image_path, output_path, threshold=128):
    """
    Applies sequential error diffusion dithering to an image and saves the result.

    Parameters:
    - image_path: str, path to the input image.
    - output_path: str, path to save the dithered image.
    - threshold: int, threshold value for dithering (default is 128).
    """
    # Load image and convert to grayscale
    img = Image.open(image_path).convert('L')
    img_array = np.array(img, dtype=np.int32)

    # Initialize output array
    dithered_img = np.zeros_like(img_array)

    # Get image dimensions
    height, width = img_array.shape

    # Sequential error diffusion
    for y in range(height):
        for x in range(width):
            old_pixel = img_array[y, x]
            new_pixel = 255 if old_pixel > threshold else 0
            dithered_img[y, x] = new_pixel
            quant_error = int(old_pixel - new_pixel)

            # Distribute the quantization error to neighboring pixels
            if x + 1 < width:
                img_array[y, x + 1] += int((quant_error * 7) // 16)
            if x - 1 >= 0 and y + 1 < height:
                img_array[y + 1, x - 1] += int((quant_error * 3) // 16)
            if y + 1 < height:
                img_array[y + 1, x] += int((quant_error * 5) // 16)
            if x + 1 < width and y + 1 < height:
                img_array[y + 1, x + 1] += int((quant_error * 1) // 16)

    # Save the dithered image
    dithered_image = Image.fromarray(np.clip(dithered_img, 0, 255).astype(np.uint8))
    dithered_image.save(output_path)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python error_diffusion.py <input_image_path> <output_image_path>")
        sys.exit(1)
    input_image_path = sys.argv[1]
    output_image_path = sys.argv[2]
    seq_error_diffusion(input_image_path, output_image_path)  