import json

# ONLY OCR confirmed data from the image - no interpolation for missing years
# (保单年度, 年龄, 含分红现金价值, 含分红年领, 含分红累计年领)
data = [
    (1, 36, 3912, 0, 0),
    (2, 37, 9509, 0, 0),
    (3, 38, 16175, 0, 0),
    (4, 39, 23616, 0, 0),
    (5, 40, 31514, 0, 0),
    (6, 41, 39896, 0, 0),
    (7, 42, 48788, 0, 0),
    (8, 43, 58220, 0, 0),
    (9, 44, 68222, 0, 0),
    (10, 45, 78826, 0, 0),
    (11, 46, 90065, 0, 0),
    (12, 47, 101977, 0, 0),
    (13, 48, 114597, 0, 0),
    (14, 49, 127964, 0, 0),
    (15, 50, 142120, 0, 0),
    (16, 51, 157109, 0, 0),
    (17, 52, 172976, 0, 0),
    (18, 53, 189772, 0, 0),
    (19, 54, 207549, 0, 0),
    (20, 55, 226360, 0, 0),
    (21, 56, 238150, 0, 0),
    (23, 58, 263639, 0, 0),
    (25, 60, 275825, 16297, 16297),
    (26, 61, 271580, 16795, 49635),
    (29, 64, None, 17312, 83998),
    (30, 65, 286815, 17850, None),
    (33, 68, 276006, 18409, 155962),
    (35, 70, 263792, 18992, 193651),
    (37, 72, 232542, 19599, 250282),
    (39, 74, 235709, 20332, 272685),
    (41, 76, 220489, 20892, 314135),
    (43, 78, 205288, 21578, 356945),
    (45, 80, None, 22289, 401164),
    (47, 82, None, 23027, 446846),
    (49, 84, None, 23797, 494052),
    (51, 86, None, 24604, 542851),
    (53, 88, None, 25453, 593327),
    (55, 90, None, 26352, 645575),
    (57, 92, None, 27308, 699705),
    (59, 94, None, 28328, 755842),
    (61, 96, None, 29420, 814126),
    (63, 98, None, 30587, 874708),
    (65, 100, None, 31834, 937742),
]

# Save as JSON
output = []
for row in data:
    y, age, cv, pen, cum = row
    cum_prem = 12000 * min(y, 20)
    irr = ''
    if y >= 25 and (cum or 0) > 0 and cv is not None:
        total = (cum or 0) + cv
        if total > cum_prem and cum_prem > 0:
            irr_val = (total / cum_prem) ** (1.0/y) - 1
            irr = f"{irr_val*100:.2f}%"
    output.append({
        'year': y, 'age': age, 'cum_prem': cum_prem,
        'cv': cv, 'pension': pen, 'cum_pension': cum, 'irr': irr
    })

with open(r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ocr_full_data.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print(f"Saved {len(output)} confirmed data rows")
for d in output:
    cv_str = f"{d['cv']:,}" if d['cv'] else "-"
    cum_str = f"{d['cum_pension']:,}" if d['cum_pension'] else "-"
    pen_str = f"{d['pension']:,}" if d['pension'] else "-"
    print(f"Y{d['year']:2d}({d['age']:2d}yo): prem={d['cum_prem']:>7,} CV={cv_str:>10s} pen={pen_str:>6s} cum={cum_str:>8s} irr={d['irr']}")
