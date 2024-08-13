#!/bin/bash

# Variables
PROJECT_ID="world-learning-400909"
echo "Deleting GCP Resources on" $PROJECT_ID
# Delete Cloud Run services
gcloud run services delete pdf-convert-pubsub --project=$PROJECT_ID --region=us-central1 --quiet
gcloud run services delete metadata-pubsub --project=$PROJECT_ID --region=us-central1 --quiet
gcloud run services delete image-pubsub --project=$PROJECT_ID --region=us-central1 --quiet
gcloud run services delete file-upload-pubsub --project=$PROJECT_ID --region=us-central1 --quiet

# Delete GKE cluster (which should also delete associated disks)
gcloud container clusters delete disearch-cluster --project=$PROJECT_ID --region=us-central1-c --quiet

# Delete Serverless VPC connector
gcloud compute networks vpc-access connectors delete disearch-vpc-connector --project=$PROJECT_ID --region=us-central1 --quiet

# Release static IP address
gcloud compute addresses delete google-managed-services-default --project=$PROJECT_ID --global --quiet

# Delete subnets
gcloud compute networks subnets delete uscentral-disearch-vpc01-subnet1000024 --project=$PROJECT_ID --region=us-central1 --quiet
gcloud compute networks subnets delete uscentral-disearch-vpc01-subnet1010016-gke --project=$PROJECT_ID --region=us-central1 --quiet

# Delete disks
gcloud compute disks delete pd-ssd-disk-1 --project=$PROJECT_ID --zone=us-central1-a --quiet

# Delete GCP Secrets
gcloud secrets delete APP_VERSION --project=$PROJECT_ID --quiet
gcloud secrets delete aretec_admin --project=$PROJECT_ID --quiet
gcloud secrets delete DB_HOST --project=$PROJECT_ID --quiet
gcloud secrets delete DB_PASSWORD --project=$PROJECT_ID --quiet
gcloud secrets delete DB_USER --project=$PROJECT_ID --quiet
gcloud secrets delete DOCUMENT_CHAT_URL --project=$PROJECT_ID --quiet
gcloud secrets delete GCP_BUCKET --project=$PROJECT_ID --quiet
gcloud secrets delete image_summary_cloud_fn --project=$PROJECT_ID --quiet
gcloud secrets delete IS_VERTEXAI --project=$PROJECT_ID --quiet
gcloud secrets delete LOG_INDEX --project=$PROJECT_ID --quiet
gcloud secrets delete LOGS_URL --project=$PROJECT_ID --quiet
gcloud secrets delete metadata_cloud_fn --project=$PROJECT_ID --quiet
gcloud secrets delete OPENAI_API_KEY --project=$PROJECT_ID --quiet
gcloud secrets delete pdf_loadbalancer --project=$PROJECT_ID --quiet
gcloud secrets delete project_id --project=$PROJECT_ID --quiet
gcloud secrets delete redis-url --project=$PROJECT_ID --quiet
gcloud secrets delete SCHEMA --project=$PROJECT_ID --quiet
gcloud secrets delete service_key --project=$PROJECT_ID --quiet
gcloud secrets delete status_cloud_fn --project=$PROJECT_ID --quiet
gcloud secrets delete storage_bucket --project=$PROJECT_ID --quiet
gcloud secrets delete terraform_state --project=$PROJECT_ID --quiet
gcloud secrets delete vertexai_citation --project=$PROJECT_ID --quiet
gcloud secrets delete vertexai_followup --project=$PROJECT_ID --quiet
gcloud secrets delete vertexai_python_url --project=$PROJECT_ID --quiet
gcloud secrets delete vertexai-referer --project=$PROJECT_ID --quiet
gcloud secrets delete vertexai-summary --project=$PROJECT_ID --quiet

# Delete Pub/Sub topics and subscriptions
gcloud pubsub topics delete dead-letter-topic --project=$PROJECT_ID --quiet
gcloud pubsub topics delete file-process-topic --project=$PROJECT_ID --quiet
gcloud pubsub topics delete image-topic --project=$PROJECT_ID --quiet
gcloud pubsub topics delete metadata-topic --project=$PROJECT_ID --quiet
gcloud pubsub topics delete pdf-convert-topic --project=$PROJECT_ID --quiet
gcloud pubsub subscriptions delete file-process-subscription --project=$PROJECT_ID --quiet
gcloud pubsub subscriptions delete image-subscription --project=$PROJECT_ID --quiet
gcloud pubsub subscriptions delete metadata-subscription --project=$PROJECT_ID --quiet
gcloud pubsub subscriptions delete pdf-subscription --project=$PROJECT_ID --quiet

# Delete SQL database
gcloud sql instances delete disearch-db --project=$PROJECT_ID --quiet

# Delete GCP buckets
gsutil rm -r gs://terraform-state-yx27era3
gsutil rm -r gs://disearch-storage-bucket-40zag3ju

# Delete Cloud Functions
gcloud functions delete uploader-trigger --project=$PROJECT_ID --region=us-central1 --quiet
gcloud functions delete update_metadata_ingested_document --project=$PROJECT_ID --region=us-central1 --quiet
gcloud functions delete image-processing --project=$PROJECT_ID --region=us-central1 --quiet
gcloud functions delete document-status --project=$PROJECT_ID --region=us-central1 --quiet

# Delete Service Accounts
gcloud iam service-accounts delete terraform@$PROJECT_ID.iam.gserviceaccount.com --quiet

echo "All specified resources have been deleted."
