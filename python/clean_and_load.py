import pandas as pd
import ast
import os

# ── Absolute paths — works regardless of where VSCode runs from ────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RAW_DIR = os.path.join(BASE_DIR, '..', 'data', 'raw')
CLEANED_DIR = os.path.join(BASE_DIR, '..', 'data', 'cleaned')

os.makedirs(CLEANED_DIR, exist_ok=True)
os.makedirs(RAW_DIR, exist_ok=True)

# ── Load raw data ───────────────────────────────────────────────────
df = pd.read_csv(os.path.join(RAW_DIR, 'job_postings.csv'), dtype=str, low_memory=False)
print(f"Raw dataset loaded: {len(df)} rows, {df.shape[1]} columns")

# ── Drop useless columns ────────────────────────────────────────────
drop_cols = ['Unnamed: 0', 'index', 'thumbnail', 'commute_time', 'via', 'extensions']
df.drop(columns=[c for c in drop_cols if c in df.columns], inplace=True)

# ── Clean dates ─────────────────────────────────────────────────────
df['date_time'] = pd.to_datetime(df['date_time'], errors='coerce')
df['posted_month'] = df['date_time'].dt.to_period('M').astype(str)

# ── Clean location ──────────────────────────────────────────────────
df['location'] = df['location'].fillna('Unknown').str.strip()
df['search_location'] = df['search_location'].fillna('Unknown').str.strip()

# ── Clean work_from_home ────────────────────────────────────────────
df['work_from_home'] = df['work_from_home'].fillna(False).astype(bool)

# ── Clean salary columns ────────────────────────────────────────────
for col in ['salary_avg', 'salary_yearly', 'salary_hourly', 'salary_min', 'salary_max']:
    if col in df.columns:
        df[col] = pd.to_numeric(df[col], errors='coerce')

# ── Keep key columns ────────────────────────────────────────────────
cols = [
    'job_id', 'title', 'company_name', 'location', 'search_location',
    'date_time', 'posted_month', 'work_from_home', 'schedule_type',
    'salary_avg', 'salary_yearly', 'salary_hourly',
    'salary_min', 'salary_max', 'salary_rate',
    'description_tokens'
]
df = df[[c for c in cols if c in df.columns]]

# ── Remove duplicates ───────────────────────────────────────────────
before = len(df)
df.drop_duplicates(subset='job_id', inplace=True)
print(f"Duplicates removed: {before - len(df)}")

# ── Save cleaned master file ────────────────────────────────────────
df.to_csv(os.path.join(CLEANED_DIR, 'job_postings_clean.csv'), index=False)
print(f"✅ job_postings_clean.csv saved: {len(df)} rows")

# ── Explode skills ──────────────────────────────────────────────────
skills_df = df[['job_id', 'description_tokens']].dropna(subset=['description_tokens'])

def parse_skills(s):
    try:
        return ast.literal_eval(s)
    except:
        return []

skills_df = skills_df.copy()
skills_df['skill'] = skills_df['description_tokens'].apply(parse_skills)
skills_exploded = skills_df.explode('skill')[['job_id', 'skill']]
skills_exploded['skill'] = skills_exploded['skill'].str.strip().str.lower()
skills_exploded = skills_exploded.dropna(subset=['skill'])
skills_exploded = skills_exploded[skills_exploded['skill'] != '']

# ── Save exploded skills file ───────────────────────────────────────
skills_exploded.to_csv(os.path.join(CLEANED_DIR, 'job_skills_exploded.csv'), index=False)
print(f"✅ job_skills_exploded.csv saved: {len(skills_exploded)} rows")

# ── Sanity check ────────────────────────────────────────────────────
print("\n── Salary coverage ──────────────────────────")
print(f"salary_avg non-null:     {df['salary_avg'].notna().sum()}")
print(f"salary_yearly non-null:  {df['salary_yearly'].notna().sum()}")
print(f"salary_hourly non-null:  {df['salary_hourly'].notna().sum()}")

print("\n── Top 10 job titles ────────────────────────")
print(df['title'].value_counts().head(10))

print("\n── Top 10 skills ────────────────────────────")
print(skills_exploded['skill'].value_counts().head(10))

print("\n✅ All done. Python phase complete — move to SQL.")