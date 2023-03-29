from PIL import Image
import argparse
def convert(image_file):
    image = Image.open(image_file)
    image = image.resize((80, 80), Image.NEAREST)
    image = image.convert('L')
    chars = "@%#*+=-:. "
    result = ""
    for i in range(image.height):
        for j in range(image.width):
            gray = image.getpixel((j, i))
            unit = (256.0 + 1) / len(chars)
            result += chars[int(gray / unit)]
        result += '\n'
    return result
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('file')
    parser.add_argument('-o', '--output')
    parser.add_argument('--width', type=int, default=80)
    parser.add_argument('--height', type=int, default=80)
    args = parser.parse_args()
    image_file = args.file
    width = args.width
    height = args.height
    output = args.output
    result = convert(image_file)
    if output:
        with open(output, 'w') as f:
            f.write(result)
    else:
        with open('output.txt', 'w') as f:
            f.write(result)
if __name__ == '__main__':
    main()