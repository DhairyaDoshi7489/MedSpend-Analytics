# MedSpend Analytics

### 1. Introduction

This repository hosts a comprehensive data analytics solution designed to evaluate global healthcare expenditure trends over a multi-decade span (1970–2016). The application processes historical economic data to uncover critical insights regarding national spending habits, per capita cost disparities, and regional healthcare development.

The core problem this system solves is the complexity of interpreting raw, disparate economic data. By transforming unstructured csv datasets into actionable intelligence, it allows stakeholders—such as policy makers, financial analysts, and public health researchers—to visualize where healthcare resources are being allocated and how spending models have evolved relative to GDP growth globally.

---

### 2. Architecture Overview

The system follows a classic Extract-Load-Transform-Visualize (ELTV) architecture, prioritizing data integrity and analytical depth.

#### High-Level Design (HLD)

The architecture is composed of three primary layers:

* **Data Ingestion Layer:** Handles the raw historical data (CSV format) encompassing metrics like total spending, USD per capita, and GDP ratios.
* **Processing & Logic Layer (SQL):** A relational database engine performs complex aggregations, filtering, and windowing functions to derive secondary metrics (e.g., "Spending Above Average").
* **Presentation Layer (Power BI):** An interactive dashboard layer that consumes the processed datasets to render dynamic visualizations.

**Plaintext architecture diagram**

```
+-----------------+       +---------------------+       +-------------------------+
|  Raw Data Src   | ----> |  Database Engine    | ----> |   Analytics Dashboard   |
| (CSV / Flat Files)|     | (SQL Processing)    |       |      (Power BI)         |
+-----------------+       +---------------------+       +-------------------------+
        |                            |                              |
    [Ingestion]                 [Transformation]               [Visualization]
  - Historical Logs           - Data Cleaning                - Trend Analysis
  - Economic Metrics          - CTEs & Aggregations          - Geospatial Mapping
                              - Metric Derivation            - Interactive Filtering
```

#### Low-Level Design (LLD)

**Data Transformation Module (SQL):**

* **Aggregation Logic:** Implements GROUP BY clauses to summarize unique temporal data points (e.g., Year Counts per Location).
* **Comparative Analysis:** Utilizes Common Table Expressions (CTEs), such as GlobalAvg, to isolate high-spending nations by comparing individual USD_CAP against global averages dynamically.
* **Conditional Logic:** Complex CASE statements segment countries into economic tiers (e.g., identifying countries with >200 USD per capita spending vs. those below).

**Visualization Controller:**

* Connects directly to the transformed SQL views.
* Manages relationships between Location, Time, and Spending tables to allow cross-filtering on the dashboard.

---

### 3. Use Cases / Real-World Applications

This analytical framework is applicable in various high-impact scenarios:

* **Government Policy & Resource Allocation:**

  * *Scenario:* A Ministry of Health needs to benchmark its spending against peer nations to justify budget increases.
  * *Application:* The dashboard highlights how developed nations (e.g., USA, Germany) scale spending over time, providing a comparative baseline for policy adjustments.

* **Investment Strategy in Private Healthcare:**

  * *Scenario:* Private equity firms seek emerging markets where healthcare spending is accelerating.
  * *Application:* The "Total Spending Above Average" metric identifies regions with rapid infrastructure growth, signaling investment maturity.

* **Public Health Research:**

  * *Scenario:* Epidemiologists analyzing the correlation between spending spikes and health outcomes.
  * *Application:* Researchers use the longitudinal data (1970-2015) to map spending surges against historical health crises or technological advancements.

---

### 4. Technical Details

**Tech Stack**

* Database: SQL (Relational Database Management System) for structured querying and data manipulation.
* Visualization: Power BI for business intelligence reporting and interactive dashboarding.
* Data Source: Structured CSV datasets (Historical Health Data).

**Key Architectural Choices**

* **Common Table Expressions (CTEs):** Used in the SQL layer (e.g., WITH GlobalAvg AS...) to break down complex queries. This modular approach improves readability and allows for the re-use of calculated averages without recalculating them for every row, optimizing query performance.
* **Pre-Aggregation Strategy:** Heavy calculations (sums, averages, rounding) are offloaded to the SQL layer rather than the visualization tool. This ensures the Power BI dashboard remains lightweight and responsive, even as the dataset grows.
* **Data Normalization:** The filtering queries (e.g., WHERE TIME between 1980 and 2010) ensure that the analysis focuses on the most data-rich periods, preventing skewed results from eras with sparse reporting.

---

### 5. Setup & Running the Project

**Prerequisites**

* A SQL Environment (MySQL Workbench, PostgreSQL, or SQL Server).
* Microsoft Power BI Desktop.
* Git.

**Installation Steps**

1. **Clone the Repository:**

```bash
git clone [repository-url]
cd [repository-folder]
```

2. **Database Configuration:**

* Import the CSV files located in the `data/` folder into your SQL database.
* Ensure the table name matches `healthdata` or update the SQL scripts accordingly.

3. **Execute Transformation Scripts:**

* Open `sql/healthdataquerry.sql` in your SQL editor.
* Execute the queries to verify data integrity and generate the analytical views.

4. **Launch Dashboard:**

* Open `dashboards/Healthcare_Spending.pbix` in Power BI.
* *Note:* You may need to update the data source settings in Power BI to point to your local database or the CSV files if you are running it in "Import" mode.

---

### 6. Additional Enhancements

**Future Improvements**

* **Automated ETL Pipeline:** Integrating Python (Pandas/Airflow) to automatically fetch and clean new World Bank data would make the system "live" rather than static.
* **Predictive Modeling:** Incorporating a machine learning layer (e.g., Scikit-Learn) to forecast future spending trends based on the historical trajectory established in the SQL analysis.
* **API Integration:** Exposing the processed SQL data via a REST API (using Flask or FastAPI) to allow other web applications to consume these metrics.

**Performance Considerations**

* **Data Completeness:** Users should be aware that the YEARS_COUNT query reveals data gaps for certain developing nations. Analysis on these regions should be treated with statistical caution.
* **Scaling:** As the dataset expands beyond 2016, indexing the `LOCATION` and `TIME` columns in the SQL database will be crucial to maintain sub-second query performance.

---
