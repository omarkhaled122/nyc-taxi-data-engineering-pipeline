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




