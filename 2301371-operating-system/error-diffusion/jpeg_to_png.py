from PIL import Image
import sys

if __name__ == "__main__":
    input_path = sys.argv[1]
    output_path = sys.argv[2]
    Image.open(input_path).convert('L').save(output_path)
