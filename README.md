# Walmart Sales Analysis (Kaggle → Jupyter → MySQL → Analysis)

**Repository:** `walmart-analysis`
**Author:** Nitish Sharma — GitHub: [@sharmanitish1401](https://github.com/sharmanitish1401)

---

> A complete, reproducible end-to-end data workflow that demonstrates how to obtain retail data from Kaggle, clean and transform it inside a Jupyter notebook, load the cleaned dataset into MySQL Workbench, and produce analytics and visualizations. This repository is designed as a portfolio-ready example for data analysts and data engineers.

---

# Table of Contents

1. [Project Summary](#project-summary)
2. [What’s Included](#whats-included)
3. [Why this Project](#why-this-project)
4. [Prerequisites](#prerequisites)
5. [Quick Start (Step-by-step)](#quick-start-step-by-step)
6. [Detailed Workflow](#detailed-workflow)
7. [Environment & Dependencies](#environment--dependencies)
8. [Data — Downloading & Handling](#data----downloading--handling)
9. [MySQL Integration](#mysql-integration)
10. [Common Issues & Fixes](#common-issues--fixes)
11. [Project Structure (Recommended)](#project-structure-recommended)
12. [Reproducibility & Best Practices](#reproducibility--best-practices)
13. [Contributing](#contributing)
14. [License & Credits](#license--credits)
15. [Contact / Follow](#contact--follow)

---

# Project Summary

This project takes a Walmart retail dataset (sourced from Kaggle) through a practical pipeline:

1. Ingest raw CSV files into a Jupyter notebook.
2. Profile the data and perform cleaning & feature engineering (dates, numeric conversions, missing values, category normalization).
3. Export cleaned data to CSV and push into a MySQL database using SQLAlchemy / PyMySQL.
4. Run SQL-powered analysis and create visualizations (time series, branch comparisons, payment method analysis, profit calculations, heatmaps, top items, etc.).
5. Provide `walmart.sql` with table creation queries and representative SQL analytics used in Workbench.

This repository is intended to be read, reproduced, and extended by anyone learning practical data workflows.

---

# What’s Included

* `WALMART.ipynb` — Main Jupyter notebook containing:

  * Data ingestion and profiling
  * Cleaning & transformations
  * Feature engineering
  * Export -> MySQL commands
  * Visualization cells and analysis commentary
* `walmart.sql` — SQL dump / sample queries (schema, sample analytics)
* `.gitignore` — Recommended rules to keep environment & dataset files out
* `requirements.txt` — Baseline package list (update versions as required)
* `data/` — placeholder (raw dataset is **not** included — see Data section)

> Note: Large raw data files are intentionally excluded from the repo. See the Data section for instructions to download the dataset from Kaggle.

---

# Why this Project

* Demonstrates a realistic end-to-end pipeline (not just isolated scripts).
* Teaches practical data cleaning decisions and rationale.
* Shows how to integrate Python analysis with a SQL database (MySQL).
* Useful as a portfolio piece when applying to analyst / BI roles.
* Ready for extension: add automated tests, CI, dashboarding, or production data pipelines.

---

# Prerequisites

* Python 3.8+
* Git (command line or GUI)
* MySQL Server & MySQL Workbench (or other MySQL client)
* (Optional) Kaggle account + Kaggle CLI for programmatic downloads
* (Recommended) Virtual environment tool: `venv` or `conda`

---

# Quick Start (Step-by-step)

1. **Clone the repo (replace repo name if different):**

   ```bash
   git clone https://github.com/sharmanitish1401/walmart-analysis.git
   cd walmart-analysis
   ```

2. **Create & activate a virtual environment and install dependencies:**

   ```bash
   python -m venv .venv
   # Windows
   .venv\Scripts\activate
   # macOS / Linux
   source .venv/bin/activate

   pip install -r requirements.txt
   ```

3. **Download dataset to `data/` (see Data section)**

4. **Open the notebook:**

   ```bash
   jupyter notebook WALMART.ipynb
   # or
   jupyter lab
   ```

   Run cells sequentially and follow inline notes.

5. **Push cleaned data to MySQL** (example in notebook uses SQLAlchemy).

6. **Run SQL queries** either via the notebook or import `walmart.sql` into MySQL Workbench.

---

# Detailed Workflow (what each step covers)

* **Data ingestion**: read CSVs, initial shape & head, basic integrity checks.
* **Profiling**: null percentage, unique value counts, dtype checks, sample distributions.
* **Cleaning**: dtype conversion (strings → datetimes, numerics), trimming, filling/dropping nulls, removing duplicates, normalizing categories.
* **Feature engineering**: create `year`, `month`, `weekday`, `time_of_day`, `total_price`, `profit`, `order_count` per invoice, category aggregates.
* **Export**: save cleaned dataset to `data/cleaned_walmart.csv` and push to MySQL using SQLAlchemy.
* **Exploratory analysis**: time-series sales, branch ranking, payment method share, ratings distribution, store performance heatmap, top-selling SKUs.
* **SQL examples**: aggregation queries, window functions (if MySQL version supports), sample indexes to accelerate reports.

---

# Environment & Dependencies

Use the included `requirements.txt` as a baseline. Install into your environment:

```
pandas
sqlalchemy
pymysql
jupyterlab
notebook
kaggle
tqdm
```

**Tip:** After installing and confirming your notebook runs, you can freeze exact versions:

```bash
pip freeze > requirements.txt
```

Then trim unrelated packages manually for cleanliness.

---

# Data — Downloading & Handling

**Important:** Raw dataset is **not** stored in this repository to avoid large commits.

**Option A — Kaggle CLI (recommended):**

1. Install Kaggle CLI:

   ```bash
   pip install kaggle
   ```
2. Place your `kaggle.json` (API token) in `~/.kaggle/` and set file permissions:

   ```bash
   mkdir -p ~/.kaggle
   mv ~/Downloads/kaggle.json ~/.kaggle/
   chmod 600 ~/.kaggle/kaggle.json
   ```
3. Download (replace slug):

   ```bash
   kaggle datasets download -d <dataset-owner>/<dataset-name> -p data/
   unzip data/<file>.zip -d data/
   ```

**Option B — Manual Download:**
Download from Kaggle web UI and move CSVs into the `data/` folder.

**Large files:** If dataset is large, consider:

* Using Git LFS (`git lfs install`, `git lfs track "*.csv"`), or
* Hosting data in cloud (S3, GDrive) and providing download scripts.

---

# MySQL Integration

**Push cleaned DataFrame to MySQL** — example using SQLAlchemy:

```python
from sqlalchemy import create_engine
import os

# Use environment variables to avoid hardcoding credentials:
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASS = os.getenv("MYSQL_PASS", "your_password")
MYSQL_HOST = os.getenv("MYSQL_HOST", "localhost")
MYSQL_PORT = os.getenv("MYSQL_PORT", "3306")
MYSQL_DB = os.getenv("MYSQL_DB", "walmart")

engine = create_engine(f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASS}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}")

# df_cleaned is the cleaned pandas DataFrame
df_cleaned.to_sql("walmart_table", con=engine, if_exists="replace", index=False)
```

**Load `walmart.sql` into MySQL Workbench:**
Open the file in Workbench and execute, or run from terminal:

```bash
mysql -u root -p walmart < walmart.sql
```

**Security:** Never hardcode DB credentials in the repo. Use `.env` files with `python-dotenv` or environment variables (and add `.env` to `.gitignore`).

---

# Common Issues & Fixes

### 1) `RuntimeError: 'cryptography' package is required for sha256_password or caching_sha2_password auth methods`

Cause: MySQL user uses `caching_sha2_password` (default on MySQL 8+).
Fix:

```bash
pip install cryptography
```

Or change MySQL authentication plugin (less recommended):

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
```

### 2) `create_engine` not found / SQLAlchemy errors

Make sure SQLAlchemy is installed and imported:

```bash
pip install sqlalchemy pymysql
```

And in Python:

```python
from sqlalchemy import create_engine
```

### 3) Notebook cells failing due to missing packages

Install missing packages into same environment where Jupyter server is running. Use `%pip install package` inside a notebook cell to ensure kernel uses the installed package.

---

# Project Structure (recommended)

```
walmart-analysis/
├─ WALMART.ipynb
├─ walmart.sql
├─ requirements.txt
├─ README.md

```

**Optional directories for maturity:**

* `notebooks/` — multiple notebooks with different experiments
* `src/` — reusable scripts like `load_to_mysql.py`, `etl.py`
* `reports/` — exported images, PDF reports or slides
* `.github/workflows/` — CI workflows (e.g., nbconvert or tests)

---

# Reproducibility & Best Practices

* Use virtual environments (`venv`, `conda`) and pin package versions.
* Use environment variables for credentials; do **not** commit secrets.
* Keep raw/proprietary data out of the repo. Provide scripts to fetch data instead.
* Use clear notebook cell titles and narrative text explaining why each step exists (not just what it does).
* Consider converting notebooks to scripts for production ETL flows.
* Add a `LICENSE` (MIT recommended) if you want others to reuse freely.

---

# Contributing

Contributions, suggestions, and improvements are welcome.

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-change`
3. Make changes & commit with descriptive messages
4. Push and open a Pull Request

Please keep data, keys, and credentials out of code. When submitting code that requires credentials, use environment variables and provide sample `.env.example`.

---

# License & Credits

This repository is suitable for an **MIT License**. Add a `LICENSE` file to the root with MIT text if you choose.

**Data Source:** Kaggle 
**Author / Maintainer:** Nitish Sharma — [@sharmanitish1401](https://github.com/sharmanitish1401)

---

# Contact / Follow

* GitHub: [@sharmanitish1401](https://github.com/sharmanitish1401)
