import pandas as pd
import os
from sqlalchemy import create_engine, text

# ── Paths ───────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CLEANED_DIR = os.path.join(BASE_DIR, '..', 'data', 'cleaned')

# ── Load cleaned CSVs ───────────────────────────────────────
print("Reading cleaned files...")
df = pd.read_csv(os.path.join(CLEANED_DIR, 'job_postings_clean.csv'), dtype=str, low_memory=False)
skills = pd.read_csv(os.path.join(CLEANED_DIR, 'job_skills_exploded.csv'), dtype=str, low_memory=False)
print(f"job_postings:        {len(df)} rows")
print(f"job_skills_exploded: {len(skills)} rows")

# ── Connect to SQL Server ───────────────────────────────────
print("\nConnecting to SQL Server...")
engine = create_engine(
    "mssql+pyodbc://HEXAGON/JobMarketIntelligence"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
    "&timeout=30"
)

# ── Test connection ─────────────────────────────────────────
try:
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print("✅ Connected to SQL Server successfully")
except Exception as e:
    print(f"❌ Connection failed: {e}")
    exit()

# ── Load job_postings ───────────────────────────────────────
print("\nLoading job_postings... (may take 1-2 mins, please wait)")
df.to_sql('job_postings', engine, if_exists='replace', index=False, chunksize=1000)
print("✅ job_postings loaded")

# ── Load job_skills_exploded ────────────────────────────────
print("Loading job_skills_exploded...")
skills.to_sql('job_skills_exploded', engine, if_exists='replace', index=False, chunksize=1000)
print("✅ job_skills_exploded loaded")

print("\n✅ All done. Go verify in SSMS with SELECT COUNT(*)")