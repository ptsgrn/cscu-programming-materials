from PIL import Image
import sys
import numpy as np
import matplotlib.pyplot as plt

def convert_to_1bit(image):
    """
    Converts a grayscale image to 1-bit (black and white).
    Parameters:
    - image: numpy array, input grayscale image.
    Returns:
    - onebit_img: numpy array, 1-bit image.
    """
    # Initialize output array
    onebit_img = np.zeros_like(image)

    # Get image dimensions
    height, width = image.shape

    for i in range(height):
        for j in range(width):
            old_pixel = image[i, j]
            new_pixel = 1 if old_pixel > 128 else 0
            onebit_img[i, j] = new_pixel

    return onebit_img

def error_diffusion_similarity(img1_path, img2_path):
    """
    Compares two images using error diffusion similarity and highlights differences.
    Parameters:
    - img1_path: str, path to the first image.
    - img2_path: str, path to the second image.
    """

    # Load image and convert to grayscale
    img1 = Image.open(img1_path).convert('L')
    img2 = Image.open(img2_path).convert('L')
    img1_array = np.array(img1)
    img2_array = np.array(img2)

    # Convert images to 1-bit
    img1_1bit = convert_to_1bit(img1_array)
    img2_1bit = convert_to_1bit(img2_array)

    # Calculate similarity
    similarity = np.sum(img1_1bit == img2_1bit) / img1_1bit.size
    print(f"Similarity: {similarity * 100:.2f}%")

    # Mark the differences in red
    diff_mask = img1_1bit != img2_1bit
    # Create an RGB image from img1_1bit (scale to 0-255)
    base_rgb = np.stack([img1_1bit * 255]*3, axis=-1)
    # Set differing pixels to red ([255, 0, 0])
    base_rgb[diff_mask] = [255, 0, 0]
    difference_image = base_rgb

    # Display images
    plt.figure(figsize=(15, 5))
    plt.subplot(1, 3, 1)
    plt.title('Image 1 (1-bit)')
    plt.imshow(img1_1bit, cmap='gray')
    plt.axis('off')
    plt.subplot(1, 3, 2)
    plt.title('Image 2 (1-bit)')
    plt.imshow(img2_1bit, cmap='gray')
    plt.axis('off')
    plt.subplot(1, 3, 3)
    plt.title('Differences (Red)')
    plt.imshow(difference_image)
    plt.axis('off')
    plt.figtext(0.5, 0.01, f"Similarity: {similarity * 100:.2f}%", ha="center", fontsize=14, color="blue")
    plt.show()
    return similarity

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python bw_similarity.py <input_image1_path> <input_image1_path>")
        sys.exit(1)
    input_image1_path = sys.argv[1]
    input_image2_path = sys.argv[2]
    error_diffusion_similarity(input_image1_path, input_image2_path)