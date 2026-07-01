from PIL import Image
import os

img = Image.open(r'f:\天保星君\.uploads\reference_image.jpg')
w, h = img.size
print(f'Full image: {w}x{h}')

out_dir = r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ref_sections'
os.makedirs(out_dir, exist_ok=True)

sections = [
    ('header', 0, 0, w, int(h*0.13)),
    ('plan_info', 0, int(h*0.13), w, int(h*0.22)),
    ('table_header', 0, int(h*0.20), w, int(h*0.26)),
    ('table_early', 0, int(h*0.26), w, int(h*0.46)),
    ('table_mid', 0, int(h*0.46), w, int(h*0.66)),
    ('table_late', 0, int(h*0.66), w, int(h*0.86)),
    ('table_end', 0, int(h*0.86), w, h),
]
for name, l, t, r, b in sections:
    crop = img.crop((l, t, r, b))
    crop2x = crop.resize((w*2, (b-t)*2), Image.LANCZOS)
    path = os.path.join(out_dir, f'{name}.jpg')
    crop2x.save(path, quality=95)
    print(f'{name}: original={crop.size}, 2x={crop2x.size}, y_range={t}-{b}')
