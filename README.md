# NYC Taxi Data Engineering Pipeline 🚖

This project showcases an end-to-end Data Engineering workflow using modern tools and infrastructure. The pipeline ingests NYC Taxi trip data, processes it using Kestra, stores it in Google BigQuery. It reflects the core practices of production-grade data pipelines.

---

## 🔧 Tech Stack

- **Kestra** – Orchestration
- **Google Cloud Platform** – BigQuery, Cloud Storage
- **Terraform** – Infrastructure as Code (IaC)
- **Docker** – Containerized ingestion
- **PostgreSQL** – Testing & local dev
- **Python & SQL** – Core scripting & queries

---

## 📌 Objectives

- Demonstrate automated ingestion from public data sources (NYC Taxi)
- Implement cloud-native data storage and transformation
- Show reproducibility using Infrastructure as Code (Terraform)

---

## 📁 Project Structure

| Folder / File       | Description                                    |
|---------------------|------------------------------------------------|
| `kestra/`           | Workflow definition for orchestrating ingestion |
| `terraform/`        | Terraform modules to provision GCP resources   |
| `docker/`           | Dockerfile for ingestion container             |
| `sql/`              | Example queries and validation scripts         |
| `README.md`         | Project overview and instructions              |

---

## 🔄 Pipeline Overview

1. **Ingest**: Download Parquet files from NYC Open Data
2. **Stage**: Upload to GCP Cloud Storage
3. **Store**: Load into BigQuery via Kestra

---

## 🚀 How to Run the Project

### 1. Clone the repo
```bash
git clone https://github.com/omarkhaled122/nyc-taxi-data-engineering-pipeline.git
cd nyc-taxi-data-engineering-pipeline
```
### 2. Set up your environment
- Create a GCP project and enable BigQuery + Cloud Storage
- Create a service account and save credentials JSON
- Set up Terraform backend and initialize resources
```bash
cd terraform/
terraform init
terraform apply
```
### 3. Run Kestra Workflow

1. Start Kestra and its PostgreSQL backend using Docker Compose:

```bash
cd kestra/
docker compose -f docker-compose.base.yml up -d
````

This will spin up:

* The Kestra UI on `http://localhost:8080`
* A PostgreSQL container for workflow metadata

---

2. Open your browser and go to [http://localhost:8080](http://localhost:8080)
   Login using the default admin credentials (or configure if needed).

---

3. Create a new flow:

* In the left menu, go to **Flows → Create Flow**
* Paste the contents of `pipeline.yaml` into the editor
* Click **Save**

---

4. Update your configuration variables (KV Keys):
   Navigate to **Settings → Configuration → Variables (KV)** and add the following keys:

| Key               | Value                                                          |
| ----------------- | -------------------------------------------------------------- |
| `GCP_CREDS`       | Paste your base64-encoded GCP service account JSON credentials |
| `GCP_PROJECT_ID`  | Your GCP project ID                                            |
| `GCP_LOCATION`    | e.g., `US` or your BigQuery dataset region                     |
| `GCP_BUCKET_NAME` | Your GCP bucket name created by Terraform                      |

---

5. Optional: Modify the flow if needed
- To change the default taxi type (`green` or `yellow`), modify the value in the `inputs:` section of the flow file.
- You can disable the `purge_files` task if you want to retain intermediate output files for debugging.

---

6. Run the flow using Backfills

To execute the flow for specific months (historical or current), use Kestra's **Backfill feature**:

- In the Kestra UI, go to **Executions → Backfill**
- Select the **flow** `zoomcamp_kestra_gcp_taxi_ingestion`
- Choose the **start and end date** for the months you want to backfill
- Under **inputs**, select:
  - `green` or `yellow` for `taxi`

> ✅ This will automatically run multiple executions, one for each month, fully orchestrated with no manual file edits.

---

After successful runs, your data will be:
- Downloaded using `wget`
- Uploaded to your configured GCS bucket

---

## 📊 Example Output

* `green_trips_raw`: Ingested table in BigQuery

---

## 🙋‍♂️ Author

**Omar Khaled Elshiekh**
[LinkedIn](https://linkedin.com/in/omar-elsheikh-372997200) • [GitHub](https://github.com/omarkhaled122)

---

## 💡 Future Work

* Use dbt on top of BigQuery to apply Analytics Engineering
* Add Apache Airflow version
* Add real-time ingestion with Kafka or Pub/Sub
* Add Looker Studio dashboard or Metabase visualization




