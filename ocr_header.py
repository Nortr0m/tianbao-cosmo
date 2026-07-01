from rapidocr_onnxruntime import RapidOCR
from PIL import Image
import os

engine = RapidOCR()
img_path = r'f:\天保星君\.uploads\reference_image.jpg'
img = Image.open(img_path)
w, h = img.size

out_dir = r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ref_sections'

# Focus on header and table header area to understand columns
sections = [
    ('header_full', 0, 0, w, int(h*0.30)),
    ('table_header_detail', 0, int(h*0.18), w, int(h*0.28)),
]

for name, l, t, r, b in sections:
    crop = img.crop((l, t, r, b))
    crop3x = crop.resize((w*3, (b-t)*3), Image.LANCZOS)
    crop_path = os.path.join(out_dir, f'{name}_ocr.jpg')
    crop3x.save(crop_path, quality=98)
    
    result, elapse = engine(crop_path)
    print(f"\n=== {name} (y:{t}-{b}) ===")
    if result:
        for line in result:
            txt = line[1]
            try:
                print(f"  [{float(line[2]):.3f}] {txt}")
            except:
                print(f"  [{line[2]}] {txt}")
    else:
        print("  (no text detected)")
