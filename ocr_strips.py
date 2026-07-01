from rapidocr_onnxruntime import RapidOCR
from PIL import Image
import os

engine = RapidOCR()
img = Image.open(r'f:\天保星君\.uploads\reference_image.jpg')
w, h = img.size

out_dir = r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ref_sections'

# Narrow strips to get cleaner OCR
strips = [
    ('s1', 0, int(h*0.24), w, int(h*0.32)),  # years 1-8
    ('s2', 0, int(h*0.32), w, int(h*0.40)),  # years 8-15
    ('s3', 0, int(h*0.40), w, int(h*0.48)),  # years 15-20
    ('s4', 0, int(h*0.48), w, int(h*0.56)),  # years 20-25
    ('s5', 0, int(h*0.56), w, int(h*0.64)),  # years 25-30
    ('s6', 0, int(h*0.64), w, int(h*0.72)),  # years 30-38
    ('s7', 0, int(h*0.72), w, int(h*0.80)),  # years 38-46
    ('s8', 0, int(h*0.80), w, int(h*0.88)),  # years 46-54
    ('s9', 0, int(h*0.88), w, h),              # years 54-62
]

for name, l, t, r, b in strips:
    crop = img.crop((l, t, r, b))
    crop3x = crop.resize((w*3, (b-t)*3), Image.LANCZOS)
    crop_path = os.path.join(out_dir, f'{name}_ocr.jpg')
    crop3x.save(crop_path, quality=98)
    
    result, _ = engine(crop_path)
    if result:
        for line in result:
            txt = line[1]
            conf = line[2]
            try:
                c = float(conf)
            except:
                c = 0
            if c > 0.5:  # only high confidence
                print(txt)
