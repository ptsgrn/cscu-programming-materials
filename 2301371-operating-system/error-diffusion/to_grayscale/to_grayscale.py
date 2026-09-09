from PIL import Image
import numpy as np

def to_grayscale(image_path, output_path):

    # load image
    img = Image.open(image_path)
    
    # convert to grayscale
    grayscale_img = img.convert('L')
    
    # save the grayscale image
    grayscale_img.save(output_path)
    print(f"Grayscale image saved to {output_path}")

input_image_path = 'world.png' # input image
output_image_path = 'world-grayscale.png' # output image
to_grayscale(input_image_path, output_image_path)