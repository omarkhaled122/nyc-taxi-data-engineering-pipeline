# NYC Taxi Data Engineering Pipeline 🚖

This project showcases an end-to-end Data Engineering workflow using modern tools and infrastructure. The pipeline ingests NYC Taxi trip data, processes it using Kestra, stores it in Google BigQuery. It reflects the core practices of production-grade data pipelines.

---

## 🔧 Tech Stack

* **Kestra** – Orchestration
* **Google Cloud Platform** – BigQuery, Cloud Storage
* **Terraform** – Infrastructure as Code (IaC)
* **Docker** – Containerized ingestion
* **PostgreSQL** – Testing & local dev
* **Python & SQL** – Core scripting & queries

---

## 📌 Objectives

* Demonstrate automated ingestion from public data sources (NYC Taxi)
* Implement cloud-native data storage and transformation
* Show reproducibility using Infrastructure as Code (Terraform)

---

## 🔄 Pipeline Overview

* **Ingest**: Download Parquet files from NYC Open Data and upload to GCP buckets
* **Stage**: Load GCP buckets into BQ as native subtables
* **Store**: Merge subtables as one cumulative table

---

## 🚀 How to Run the Project

### 1. Clone the repo

```bash
git clone https://github.com/omarkhaled122/nyc-taxi-data-engineering-pipeline.git
cd nyc-taxi-data-engineering-pipeline
```

### 2. Set up your environment

* Create a GCP project and enable BigQuery + Cloud Storage
* Create a service account and save credentials JSON, then change the default value for the credentials variable in `variable.tf`:

```hcl
variable "credentials" {
  description = "Path to the Credentials file"
  default     = "./Keys/engaged-diode-459120-c8-be8fa656490a.json" # Add your credentials file's path here
}
```

* Set up Terraform backend and initialize resources:

```bash
cd terraform/
terraform init
terraform apply
```

---

### 3. Run Kestra Workflow

Start Kestra and its PostgreSQL backend using Docker Compose:

```bash
cd kestra/
docker compose -f docker-compose.yml up -d
```

This will spin up:

* The Kestra UI on [http://localhost:8080](http://localhost:8080)
* A PostgreSQL container for workflow metadata

Open your browser and go to [http://localhost:8080](http://localhost:8080)

Create a new flow:

* In the left menu, go to Flows → Create Flow → Import
* Import the 3 flows in `kestra/flows/`

Update your configuration variables (KV Keys): Navigate to Settings → Configuration → Variables (KV) and add the following keys:

> **Note:** Select `zoomcamp` as the namespace

| Key               | Value                                                          |
| ----------------- | -------------------------------------------------------------- |
| GCP\_CREDS        | Paste your base64-encoded GCP service account JSON credentials |
| GCP\_PROJECT\_ID  | Your GCP project ID                                            |
| GCP\_LOCATION     | e.g., US or your BigQuery dataset region                       |
| GCP\_BUCKET\_NAME | Your GCP bucket name created by Terraform                      |
| GCP\_DATASET      | Your BigQuery dataset                                          |

---

### 4. Execute the flow `1_ingesting_into_gcp.yaml` using Backfills

To execute the flow for specific months (historical or current), use Kestra's Backfill feature:

* In the top menu of the flow `1_ingesting_into_gcp.yaml`, go to Triggers → Backfill executions (select the green or the yellow one — there's no difference)
* Choose the start and end date for the months you want to backfill
* Under inputs, select:

  * `green` or `yellow` for taxi

✅ This will automatically run multiple executions, one for each month, fully orchestrated with no manual file edits.

After successful runs, your data will be:

* Downloaded using `wget`
* Uploaded to your configured GCP bucket

📊 **Example Output**

* `green_tripdata_2025-01.parquet`: File in the GCP Bucket

---

### 5. Execute `2_create_native_subtables.yaml` the same way

* Choose the same start and end date you chose for the first flow.
* After successful runs, new tables will be created in BigQuery in your dataset under the project you created using the files in the GCP bucket

📊 **Example Output**

* `green_tripdata_2025-01`: Table in the BQ Dataset

---

### 6. Execute `3_merge_tables.yaml`, select the input taxi (`yellow` or `green`)

* It will create a new cumulative table (if not created before)
* Merge all the subtables with the same input type (yellow or green) into that table
* Delete the subtables

📊 **Example Output**

* `green_tripdata`: Table in the BQ Dataset

---

## 📊 7. Run dbt Models on BigQuery

After the raw data has been fully loaded and merged in BigQuery, we use **dbt** to apply transformations, create fact and dimension tables, and generate documentation.

### Step-by-Step Guide

#### ➤ Install dbt and dependencies

Make sure Python ≥ 3.8 is installed, then:

```bash
pip install dbt-core dbt-bigquery
```

#### ➤ Set up your dbt profile

Inside `dbt/profiles.yml` (or `~/.dbt/profiles.yml`), use:

```yaml
nyc_taxi_pipeline:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: your-gcp-project-id
      dataset: your-dbt-dataset
      keyfile: /absolute/path/to/your/keyfile.json
      threads: 4
      timeout_seconds: 300
```

#### ➤ Navigate to the dbt directory

```bash
cd dbt/
```

#### ➤ Run the dbt pipeline

```bash
dbt deps              # Install packages (if any)
dbt seed              # (Optional) Load seed data
dbt run               # Run all models
dbt test              # Run tests from schema.yml
dbt docs generate     # Build documentation site
dbt docs serve        # Open the site locally
```

---

### 🔍 dbt Lineage Graph

Model graph of the full transformation pipeline:

![dbt Graph](resources/Graph.png)

---

## 🙋‍♂️ Author

**Omar Khaled Elshiekh**
[LinkedIn](https://www.linkedin.com/in/omarkhaled122/) • [GitHub](https://github.com/omarkhaled122)

---

## 💡 Future Work

* Use dbt on top of BigQuery to apply Analytics Engineering ✅
* Add Apache Airflow version
* Add real-time ingestion with Kafka or Pub/Sub
* Add Looker Studio dashboard or Metabase visualization
