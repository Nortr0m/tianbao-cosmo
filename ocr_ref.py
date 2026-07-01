from rapidocr_onnxruntime import RapidOCR
from PIL import Image
import os

engine = RapidOCR()
img_path = r'f:\天保星君\.uploads\reference_image.jpg'
img = Image.open(img_path)
w, h = img.size

out_dir = r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ref_sections'

# Crop and OCR each section
sections = [
    ('header', 0, 0, w, int(h*0.22)),
    ('table_early', 0, int(h*0.22), w, int(h*0.46)),
    ('table_mid', 0, int(h*0.46), w, int(h*0.70)),
    ('table_late', 0, int(h*0.70), w, int(h*0.90)),
    ('table_end', 0, int(h*0.90), h),
]

for name, l, t, r, b in sections:
    crop = img.crop((l, t, r, b))
    # Upscale 3x for better OCR
    crop3x = crop.resize((w*3, (b-t)*3), Image.LANCZOS)
    crop_path = os.path.join(out_dir, f'{name}_ocr.jpg')
    crop3x.save(crop_path, quality=98)
    
    result, elapse = engine(crop_path)
    print(f"\n=== {name} (y:{t}-{b}) ===")
    if result:
        for line in result:
            txt = line[1]
            confidence = line[2]
            try:
                print(f"  [{float(confidence):.3f}] {txt}")
            except:
                print(f"  [{confidence}] {txt}")
    else:
        print("  (no text detected)")
