from PIL import Image
import numpy as np

def convert_image_to_hex(image_path, output_path):
    # Načíst obrázek
    image = Image.open(image_path).convert('L')  # Konvertovat na stupně šedi

    # Převést obraz na černobílý
    threshold = 128  # Prahová hodnota pro konverzi na černobílý obrázek
    image = image.point(lambda p: p > threshold and 1)

    # Získat data jako numpy pole
    image_data = np.array(image, dtype=np.uint8)

    # Převést hodnoty (0 pro černou, 1 pro bílou)
    image_data = 1 - image_data  # Invertovat hodnoty: 0 pro černou, 1 pro bílou

    # Převést data do bitového pole
    bits = image_data.flatten()

    # Zapsat hexadecimální data do souboru s hlavičkou
    with open(output_path, 'w') as f:
        f.write("#  BIN2MIF Converter (c) Sviridov Georgy 2019, www.lab85.ru sgot@inbox.ru\n")
        f.write("# Ver 0.6.23\n")
        f.write("#File_format=Hex\n")
        f.write(f"#Address_depth={len(bits)}\n")  # Počet adres bude délka bitů
        f.write("#Data_width=1\n")
        for bit in bits:
            f.write(f'{bit:X}\n')

    print(f"Hex file saved as {output_path}")

# Použití skriptu
if __name__ == "__main__":
    image_path = 'path_to_your_image.png'  # Nahraďte 'path_to_your_image.png' cestou k vašemu souboru
    output_path = 'output_fixed.hex'  # Název výstupního souboru
    convert_image_to_hex(image_path, output_path)
