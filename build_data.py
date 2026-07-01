import json

# OCR confirmed data points from the image
# (保单年度, 年龄, 含分红现金价值, 含分红年领, 含分红累计年领)
confirmed = [
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
    # Y22 missing - interpolate
    (23, 58, 263639, 0, 0),
    # Y24 missing - interpolate
    (25, 60, 275825, 16297, 16297),
    (26, 61, 271580, 16795, 49635),
    # Y27 - OCR was unclear, estimate from trend
    (28, 63, None, None, None),  # unclear OCR, skip
    (29, 64, None, 17312, 83998),  # 296188 was OCR error for CV, use trend
    (30, 65, 286815, 17850, None),
    (31, 66, None, None, None),  # missing
    (32, 67, None, None, None),  # missing
    (33, 68, 276006, 18409, 155962),
    (34, 69, None, None, None),  # missing
    (35, 70, 263792, 18992, 193651),
    (36, 71, None, None, None),  # missing
    (37, 72, None, 19599, 232542),  # OCR order issue - 232,542 is likely CV, 250,282 is cum
    (38, 73, None, None, None),  # missing
    (39, 74, 235709, 20332, 272685),
    (40, 75, None, None, None),  # missing
    (41, 76, 220489, 20892, 314135),
    (42, 77, None, None, None),  # missing
    (43, 78, 205288, 21578, 356945),
    (44, 79, None, None, None),  # missing
    (45, 80, None, 22289, 401164),  # CV not directly OCR'd, but 401164 cum confirmed
    (46, 81, None, None, None),  # missing
    (47, 82, None, 23027, 446846),
    (48, 83, None, None, None),  # missing
    (49, 84, None, 23797, 494052),
    (50, 85, None, None, None),  # missing
    (51, 86, None, 24604, 542851),
    (52, 87, None, None, None),  # missing
    (53, 88, None, 25453, 593327),
    (54, 89, None, None, None),  # missing
    (55, 90, None, 26352, 645575),
    (56, 91, None, None, None),  # missing
    (57, 92, None, 27280, 699705),  # 699.705 -> 699,705
    (58, 93, None, None, None),  # missing
    (59, 94, None, 28328, 755842),
    (60, 95, None, None, None),  # missing
    (61, 96, None, 29420, 814126),
    (62, 97, None, None, None),  # missing
    (63, 98, None, 30587, 874708),
    (64, 99, None, None, None),  # missing
    (65, 100, None, 31834, 937742),
]

# Now interpolate missing values
# Build a lookup dict
cv_map = {}
pension_map = {}
cum_map = {}
for row in confirmed:
    y, age, cv, pen, cum = row
    if cv is not None: cv_map[y] = cv
    if pen is not None: pension_map[y] = pen
    if cum is not None: cum_map[y] = cum

# Interpolate CV for missing years
def interpolate_cv(y):
    if y in cv_map: return cv_map[y]
    # Find nearest known years
    lower = max(k for k in cv_map if k < y)
    upper = min(k for k in cv_map if k > y)
    if lower and upper:
        t = (y - lower) / (upper - lower)
        return int(cv_map[lower] + t * (cv_map[upper] - cv_map[lower]))
    return None

def interpolate_pension(y):
    if y in pension_map: return pension_map[y]
    if y < 25: return 0
    lower = max(k for k in pension_map if k < y)
    upper = min(k for k in pension_map if k > y)
    if lower and upper:
        t = (y - lower) / (upper - lower)
        return int(pension_map[lower] + t * (pension_map[upper] - pension_map[lower]))
    return None

def interpolate_cum(y):
    if y in cum_map: return cum_map[y]
    if y < 25: return 0
    # For cum, we can compute from pension
    prev_cum = interpolate_cum(y-1) or 0
    pen = interpolate_pension(y) or 0
    return prev_cum + pen

# Generate complete table
full_data = []
for y in range(1, 66):
    age = 35 + y
    cv = interpolate_cv(y)
    pen = interpolate_pension(y)
    cum = interpolate_cum(y)
    
    # IRR calculation
    cum_prem = 12000 * min(y, 20)
    irr = ''
    if y >= 25 and cum is not None and cum + (cv or 0) > cum_prem and cum_prem > 0:
        total_out = cum + (cv or 0)
        irr_val = (total_out / cum_prem) ** (1.0/y) - 1
        irr = f"{irr_val*100:.2f}%"
    
    full_data.append({
        'year': y, 'age': age,
        'cum_prem': cum_prem,
        'cv': cv or 0,
        'pension': pen or 0,
        'cum_pension': cum or 0,
        'irr': irr
    })

# Print key years for verification
print("=== Key Years Verification ===")
key_years = [1,5,10,15,18,20,21,23,25,26,27,28,29,30,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65]
for d in full_data:
    if d['year'] in key_years:
        print(f"Y{d['year']:2d}({d['age']:2d}yo): prem={d['cum_prem']:>7,} CV={d['cv']:>8,} pen={d['pension']:>6,} cum={d['cum_pension']:>8,} irr={d['irr']}")

# Save full data
with open(r'c:\Users\Administrator\.trae-cn\work\6a411a0a224648694b11dd3e\ocr_full_data.json', 'w', encoding='utf-8') as f:
    json.dump(full_data, f, ensure_ascii=False, indent=2)
print(f"\nSaved {len(full_data)} rows to JSON")
