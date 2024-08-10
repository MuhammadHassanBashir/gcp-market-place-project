#!/bin/bash
# ██████  ██ ███████ ███████  █████  ██████   ██████ ██   ██
# ██   ██ ██ ██      ██      ██   ██ ██   ██ ██      ██   ██
# ██   ██ ██ ███████ █████   ███████ ██████  ██      ███████
# ██   ██ ██      ██ ██      ██   ██ ██   ██ ██      ██   ██
# ██████  ██ ███████ ███████ ██   ██ ██   ██  ██████ ██   ██



#  _____           _           _      _____             __ _        __      __        _       _     _
# |  __ \         (_)         | |    / ____|           / _(_)       \ \    / /       (_)     | |   | |
# | |__) | __ ___  _  ___  ___| |_  | |     ___  _ __ | |_ _  __ _   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___
# |  ___/ '__/ _ \| |/ _ \/ __| __| | |    / _ \| '_ \|  _| |/ _` |   \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
# | |   | | | (_) | |  __/ (__| |_  | |___| (_) | | | | | | | (_| |    \  / (_| | |  | | (_| | |_) | |  __/\__ \
# |_|   |_|  \___/| |\___|\___|\__|  \_____\___/|_| |_|_| |_|\__, |     \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#                _/ |                                         __/ |
#               |__/                                         |___/


echo "Project ID is $PROJECT_ID"
#PROJECT_ID="world-learning-400909"
echo "Project Number is $PROJECT_NUMBER"
#PROJECT_NUMBER="22927148231"
REGION="us-central1"
APP_NAME="disearch"
echo "Default Owner Email is $DEFAULT_OWNER_EMAIL"
#DEFAULT_OWNER_EMAIL="aareez@hypremia.com"
PULL_IMAGE_FROM='aretecinc-public'
echo "$WEBSITE_URL"
# WEBSITE_URL="apps.disearch.ai"
APP_VERSION='INDIVIDUAL'
SERVICE_ACCOUNT="gke-sa@$PROJECT_ID.iam.gserviceaccount.com"
GKE_SERVICE_ACCOUNT="gke-sa@$PROJECT_ID.iam.gserviceaccount.com"
OPEN_AI_KEY=""
RABBITMQ_PASS=""
REDIS_PASS="UmVkaXMxMjMkJV4uLg=="
TAG="1.0.8"


#Images Variables
FILE_UPLOAD_PUBSUB_ID="gcr.io/$PULL_IMAGE_FROM/disearch/file-upload-pubsub:$TAG"
IMAGE_PUBSUB_ID="gcr.io/$PULL_IMAGE_FROM/disearch/image-pubsub:$TAG"
METADATA_PUBSUB_ID="gcr.io/$PULL_IMAGE_FROM/disearch/metadata-pubsub:$TAG"
PDF_CONVERT_PUBSUB_ID="gcr.io/$PULL_IMAGE_FROM/disearch/pdf-convert-pubsub:$TAG"
DISEARCH_IMAGE_ID="gcr.io/$PULL_IMAGE_FROM/disearch/disearch:$TAG"
LLM_MODEL_IMPORT_ID="gcr.io/$PULL_IMAGE_FROM/disearch/llm-migrations:$TAG"








#                _   _                _   _           _   _
#     /\        | | | |              | | (_)         | | (_)
#    /  \  _   _| |_| |__   ___ _ __ | |_ _  ___ __ _| |_ _  ___  _ __
#   / /\ \| | | | __| '_ \ / _ \ '_ \| __| |/ __/ _` | __| |/ _ \| '_ \
#  / ____ \ |_| | |_| | | |  __/ | | | |_| | (_| (_| | |_| | (_) | | | |
# /_/    \_\__,_|\__|_| |_|\___|_| |_|\__|_|\___\__,_|\__|_|\___/|_| |_|
# Authenticating using GCP Service Account Key
echo $SERVICE_ACCOUNT_KEY > secret.json
gcloud auth activate-service-account --key-file=./secret.json
gcloud config set project $PROJECT_ID









#  _______                   __                        _____ _        _
# |__   __|                 / _|                      / ____| |      | |
#    | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___   | (___ | |_ __ _| |_ ___
#    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \   \___ \| __/ _` | __/ _ \
#    | |  __/ |  | | | (_| | || (_) | |  | | | | | |  ____) | || (_| | ||  __/
#    |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| |_____/ \__\__,_|\__\___|

# Creating Bucket for Storing Terraform State. If exist then skip to next step.
TF_BUCKET_SECRET_NAME="terraform_state"
EXISTING_TF_SECRET=$(gcloud secrets list --filter="name:$TF_BUCKET_SECRET_NAME" --format="value(name)")

if [ -n "$EXISTING_TF_SECRET" ]; then
  echo "Secret '$TF_BUCKET_SECRET_NAME' already exists. Skipping bucket creation."
  # Retrieve the bucket name from the existing secret
  TF_STATE_BUCKET_NAME=$(gcloud secrets versions access latest --secret="$TF_BUCKET_SECRET_NAME")
  echo "Bucket name retrieved from secret: $TF_STATE_BUCKET_NAME"
else
  # Generate a random string
  RANDOM_STRING=$(head /dev/urandom | tr -dc a-z0-9 | head -c 8)

  # Combine the base bucket name with the random string
  TF_STATE_BUCKET_NAME="terraform-state-$RANDOM_STRING"

  # Create the bucket
  echo "Creating bucket: gs://$TF_STATE_BUCKET_NAME"
  gcloud storage buckets create gs://$TF_STATE_BUCKET_NAME --location=$REGION

  # Create the secret and save the bucket name in it
  echo "Creating secret '$TF_BUCKET_SECRET_NAME' and saving the bucket name in it."
  echo -n "$TF_STATE_BUCKET_NAME" | gcloud secrets create $TF_BUCKET_SECRET_NAME --data-file=-

  # Add a new version of the secret with the bucket name
  echo -n "$TF_STATE_BUCKET_NAME" | gcloud secrets versions add $TF_BUCKET_SECRET_NAME --data-file=-
fi

sed -i "s/TF_BACKEND_BUCKET_NAME/$TF_STATE_BUCKET_NAME/g" main.tf
echo "Done."








#  _______                   __                                            _
# |__   __|                 / _|                         /\               | |
#    | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___      /  \   _ __  _ __ | |_   _
#    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \    / /\ \ | '_ \| '_ \| | | | |
#    | |  __/ |  | | | (_| | || (_) | |  | | | | | |  / ____ \| |_) | |_) | | |_| |
#    |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| /_/    \_\ .__/| .__/|_|\__, |
#                                                             | |   | |       __/ |
#                                                             |_|   |_|      |___/

# Apply Terraform configuration
terraform init
terraform plan -var="projectName=$PROJECT_ID"
terraform apply -var="projectName=$PROJECT_ID" -auto-approve



# Variables
gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project $PROJECT_ID

kubectl create serviceaccount gke-sa --namespace=default

gcloud iam service-accounts add-iam-policy-binding gke-sa@$PROJECT_ID.iam.gserviceaccount.com \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:$PROJECT_ID.svc.id.goog[default/gke-sa]"

kubectl annotate serviceaccount gke-sa \
--namespace default \
iam.gke.io/gcp-service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com

echo "Workload Identity setup completed."





# ____________   _   _ _____ _____ _____
# |  _  \ ___ \ | | | |  _  /  ___|_   _|
# | | | | |_/ / | |_| | | | \ `--.  | |
# | | | | ___ \ |  _  | | | |`--. \ | |
# | |/ /| |_/ / | | | \ \_/ /\__/ / | |
# |___/ \____/  \_| |_/\___/\____/  \_/

# Fetch the private IP address of the Cloud SQL instance
CLOUDSQL_INSTANCE_NAME="disearch-db"
CLOUDSQL_SECRET_NAME="DB_HOST"

# Function to get the IP address of the Cloud SQL instance
get_cloud_sql_ip() {
    gcloud sql instances describe $CLOUDSQL_INSTANCE_NAME --format="json(ipAddresses)" | jq -r '.ipAddresses[] | select(.type == "PRIVATE") | .ipAddress'
}

# Function to get the current secret value
get_secret_value() {
  gcloud secrets versions access latest --secret=$CLOUDSQL_SECRET_NAME --project=$PROJECT_ID
}

# Function to update the secret value
update_secret_value() {
  echo -n $1 | gcloud secrets versions add $CLOUDSQL_SECRET_NAME --data-file=-
}

# Fetch the Cloud SQL IP address
CLOUD_SQL_IP=$(get_cloud_sql_ip)

if [ -z "$CLOUD_SQL_IP" ]; then
  echo "Failed to fetch Cloud SQL IP address."
  exit 1
fi

# Fetch the current secret value
CURRENT_SQL_SECRET_VALUE=$(get_secret_value)

# Check if the current secret value is the same as the Cloud SQL IP address
if [ "$CURRENT_SQL_SECRET_VALUE" == "$CLOUD_SQL_IP" ]; then
  echo "The secret value is already up-to-date."
else
  # Update the secret value with the Cloud SQL IP address
  update_secret_value $CLOUD_SQL_IP
  echo "Secret value updated."
fi

# Continue to the next step
echo "Proceeding to the next step..."


SECRET_DB_HOST="DB_HOST"
SECRET_DB_PASSWORD="DB_PASSWORD"

# Retrieve the secrets from Google Secret Manager
DB_HOST=$(gcloud secrets versions access latest --secret="$SECRET_DB_HOST")
DB_PASSWORD=$(gcloud secrets versions access latest --secret="$SECRET_DB_PASSWORD")

# Generate the PostgreSQL connection string
CONN_STRING="postgresql://postgres:${DB_PASSWORD}@${DB_HOST}/postgres"

# Encode the connection string in base64
ENCODED_CONN_STRING=$(echo -n "$CONN_STRING" | base64 -w 0)

# Output the encoded connection string
echo "$ENCODED_CONN_STRING"

# Decode to verify
DECODED_CONN_STRING=$(echo $ENCODED_CONN_STRING | base64 --decode)
echo $DECODED_CONN_STRING





#  _    _ ______ _      __  __
# | |  | |  ____| |    |  \/  |
# | |__| | |__  | |    | \  / |
# |  __  |  __| | |    | |\/| |
# | |  | | |____| |____| |  | |
# |_|  |_|______|______|_|  |_|

helm repo add aretec-public https://aretec-inc.github.io/disearch-helm/
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm show values aretec-public/gke-templates > gke-values.yaml
helm show values aretec-public/redis > redis-values.yaml
helm show values aretec-public/etcd > etcd-values.yaml

gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project $PROJECT_ID

# Replacing Values
#Fetch Cluster Internal Endpoint
CLUSTER_NAME="disearch-cluster"
CLUSTER_ZONE="us-central1-c"
DOCUMENT_STATUS_CF_URL="https://us-central1-$PROJECT_ID.cloudfunctions.net/document-status"
IMAGE_PROCESSING_CF_URL="https://us-central1-$PROJECT_ID.cloudfunctions.net/image-processing"
METADATA_INJECTED_DOCUMENT_CF_URL="https://us-central1-$PROJECT_ID.cloudfunctions.net/update_metadata_ingested_document"

# Fetch the cluster endpoint using gcloud
PRIVATE_ENDPOINT=$(gcloud container clusters describe "$CLUSTER_NAME" --zone "$CLUSTER_ZONE" --format="get(privateClusterConfig.privateEndpoint)")

# Prefix with http:// and encode to base64
INTERNAL_ENDPOINT=$(echo -n "https://$PRIVATE_ENDPOINT" | base64)

# Print the result (optional)
echo "INTERNAL_ENDPOINT: $INTERNAL_ENDPOINT"

# Decode the Base64 encoded endpoint
DECODED_ENDPOINT=$(echo -n "$INTERNAL_ENDPOINT" | base64 --decode)

# Print the decoded result
echo "Decoded INTERNAL_ENDPOINT: $DECODED_ENDPOINT"

#Replace project id
sed -i "s|REPLACE_WITH_PROJECT_ID|$PULL_IMAGE_FROM|g" gke-values.yaml

sed -i "s|REPLACE_WITH_KUBEAPI_SERVER_URL|$INTERNAL_ENDPOINT|g" gke-values.yaml
echo "Updated gke-values.yaml with the internal endpoint URL."

sed -i "s/REPLACE_SQL_DB_CONNECTION/$ENCODED_CONN_STRING/g" gke-values.yaml
echo "Updated gke-values.yaml with the database connection string."

sed -i "s|REPLACE_WITH_DOCUMENT_STATUS_CF_URL|$DOCUMENT_STATUS_CF_URL|g" gke-values.yaml
echo "Updated gke-values.yaml with the Document Status CF URL."

sed -i "s|REPLACE_WITH_IMAGE_PROCESSING_CF_URL|$IMAGE_PROCESSING_CF_URL|g" gke-values.yaml
echo "Updated gke-values.yaml with the Document Status CF URL."

sed -i "s|REPLACE_WITH_UPDATE_METADATA_INJECTED_DOCUMENT|$METADATA_INJECTED_DOCUMENT_CF_URL|g" gke-values.yaml
echo "Updated gke-values.yaml with the Document Status CF URL."

sed -i "s|REPLACE_WITH_PASSWORD|$REDIS_PASS|g" redis-values.yaml
echo "Updated Redis password in redis-values.yaml."

helm upgrade --install keda kedacore/keda --namespace keda --create-namespace
helm upgrade --install gke-templates aretec-public/gke-templates --values ./gke-values.yaml
helm upgrade --install redis aretec-public/redis --values ./redis-values.yaml
helm upgrade --install etcd aretec-public/etcd --values ./etcd-values.yaml


#   _____ _                 _   ______                _   _
#  / ____| |               | | |  ____|              | | (_)
# | |    | | ___  _   _  __| | | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
# | |    | |/ _ \| | | |/ _` | |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
# | |____| | (_) | |_| | (_| | | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#  \_____|_|\___/ \__,_|\__,_| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
# Get the bucket name from Terraform output & Exporting  Bucket Variable
#

BUCKET_NAME=$(gcloud secrets versions access latest --secret="GCP_BUCKET")

# Pass the bucket name to your script
echo "Bucket name: $BUCKET_NAME"

# Clone the GitHub repository
git clone https://github.com/Aretec-Inc/uploader-trigger-cf.git
git clone https://github.com/Aretec-Inc/document-status-cf.git
git clone https://github.com/Aretec-Inc/image-process-cf.git
git clone https://github.com/Aretec-Inc/metadata-extractor-cf.git
git clone https://github.com/Aretec-Inc/pdf-convert-cf.git

GCS_SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$GCS_SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

echo "Deploying uploader-trigger"
cd uploader-trigger-cf
git checkout deployment
gcloud functions deploy uploader-trigger \
  --runtime python39 \
  --entry-point main_func \
  --set-env-vars=LOG_EXECUTION_ID=true \
  --set-secrets=bucket=projects/$PROJECT_ID/secrets/GCP_BUCKET:latest,project_id=projects/$PROJECT_ID/secrets/project_id:latest \
  --service-account $GKE_SERVICE_ACCOUNT \
  --serve-all-traffic-latest-revision \
  --vpc-connector disearch-vpc-connector \
  --trigger-bucket $BUCKET_NAME \
  --region us-central1 \
  --gen2 \
  --quiet

echo "Deploying document-status"
cd ..
cd document-status-cf
git checkout deployment
gcloud functions deploy document-status \
  --runtime python39 \
  --trigger-http \
  --entry-point main_func \
  --set-secrets 'DB_HOST=DB_HOST:latest,DB_USER=DB_USER:latest,DB_PASSWORD=DB_PASSWORD:latest' \
  --service-account  $GKE_SERVICE_ACCOUNT \
  --serve-all-traffic-latest-revision \
  --vpc-connector disearch-vpc-connector \
  --region us-central1 \
  --gen2 \
  --quiet

echo "Deploying image-processing"
cd ..
cd image-process-cf
git checkout deployment
gcloud functions deploy image-processing \
  --runtime python39 \
  --entry-point main_func \
  --service-account  $GKE_SERVICE_ACCOUNT \
  --set-env-vars=SCHEMA=disearch_search,LOG_EXECUTION_ID=true \
  --set-secrets 'LOG_INDEX=LOG_INDEX:latest,LOGS_URL=LOGS_URL:latest,gpt_key=OPENAI_API_KEY:latest' \
  --vpc-connector disearch-vpc-connector \
  --serve-all-traffic-latest-revision \
  --trigger-http \
  --gen2 \
  --region us-central1 \
  --memory 2G
  

echo "Deploying Metadata Extractor"
cd ..
cd metadata-extractor-cf
git checkout deployment
gcloud functions deploy update_metadata_ingested_document \
  --runtime python39 \
  --trigger-http \
  --entry-point main_func \
  --set-env-vars=LOG_EXECUTION_ID=true \
  --set-secrets=project_id=projects/$PROJECT_ID/secrets/project_id:latest \
  --service-account $GKE_SERVICE_ACCOUNT \
  --vpc-connector disearch-vpc-connector --region us-central1 --serve-all-traffic-latest-revision --gen2 --memory 1G
cd ..



#  _    _ _____  _         _____                    _
# | |  | |  __ \| |       / ____|                  | |
# | |  | | |__) | |      | (___   ___  ___ _ __ ___| |_ ___
# | |  | |  _  /| |       \___ \ / _ \/ __| '__/ _ \ __/ __|
# | |__| | | \ \| |____   ____) |  __/ (__| | |  __/ |_\__ \
#  \____/|_|  \_\______| |_____/ \___|\___|_|  \___|\__|___/

# Array of Cloud Functions and their corresponding secrets
declare -A FUNCTIONS_AND_SECRETS=(
  ["uploader-trigger"]="uploader_trigger_fn"
  ["document-status"]="status_cloud_fn"
  ["image-processing"]="image_summary_cloud_fn"
  ["update_metadata_ingested_document"]="metadata_cloud_fn"
)

# Function to get the URL of a Cloud Function
get_cloud_function_url() {
  local function_name=$1
  gcloud functions describe $function_name --region=$REGION --format="value(url)"
}

# Function to get the current secret value
get_secret_value() {
  local secret_name=$1
  gcloud secrets versions access latest --secret=$secret_name --project=$PROJECT_ID
}

# Function to update the secret value
update_secret_value() {
  local secret_name=$1
  local secret_value=$2
  echo -n $secret_value | gcloud secrets versions add $secret_name --data-file=-
}

# Loop through each Cloud Function and corresponding secret
for function_name in "${!FUNCTIONS_AND_SECRETS[@]}"; do
  secret_name=${FUNCTIONS_AND_SECRETS[$function_name]}

  # Fetch the Cloud Function URL
  CLOUD_FUNCTION_URL=$(get_cloud_function_url $function_name)

  if [ -z "$CLOUD_FUNCTION_URL" ]; then
    echo "Failed to fetch URL for Cloud Function: $function_name."
    continue
  fi

  # Fetch the current secret value
  CURRENT_SECRET_VALUE=$(get_secret_value $secret_name)

  # Check if the current secret value is the same as the Cloud Function URL
  if [ "$CURRENT_SECRET_VALUE" == "$CLOUD_FUNCTION_URL" ]; then
    echo "The secret value for $secret_name is already up-to-date."
  else
    # Update the secret value with the Cloud Function URL
    update_secret_value $secret_name $CLOUD_FUNCTION_URL
    echo "Secret value for $secret_name updated."
  fi
done

# Continue to the next step
echo "All secrets processed. Proceeding to next steps."









#  _____  _    _ ____   _____ _    _ ____
# |  __ \| |  | |  _ \ / ____| |  | |  _ \
# | |__) | |  | | |_) | (___ | |  | | |_) |
# |  ___/| |  | |  _ < \___ \| |  | |  _ <
# | |    | |__| | |_) |____) | |__| | |_) |
# |_|     \____/|____/|_____/ \____/|____/

echo "creating pubsub"
# Create the 'file-process-topic'
gcloud pubsub topics create file-process-topic

# Create the 'image-topic'
gcloud pubsub topics create image-topic

# Create the 'metadata-topic'
gcloud pubsub topics create metadata-topic

# Create the 'pdf-convert-topic'
gcloud pubsub topics create pdf-convert-topic

# Create the 'dead-letter-topic'
gcloud pubsub topics create dead-letter-topic

gcloud pubsub topics list

echo "creating subscriptions"
gcloud pubsub subscriptions create file-process-subscription \
    --topic=file-process-topic \
    --message-retention-duration=7d \
    --expiration-period=31d \
    --ack-deadline=600


gcloud pubsub subscriptions create image-subscription \
    --topic=image-topic \
    --message-retention-duration=7d \
    --expiration-period=31d \
    --ack-deadline=600


gcloud pubsub subscriptions create metadata-subscription \
    --topic=metadata-topic \
    --message-retention-duration=7d \
    --expiration-period=31d \
    --ack-deadline=600


gcloud pubsub subscriptions create pdf-subscription \
    --topic=pdf-convert-topic \
    --message-retention-duration=7d \
    --expiration-period=31d \
    --ack-deadline=600














#   _____ _  ________    _____                    _
#  / ____| |/ /  ____|  / ____|                  | |
# | |  __| ' /| |__    | (___   ___  ___ _ __ ___| |_ ___
# | | |_ |  < |  __|    \___ \ / _ \/ __| '__/ _ \ __/ __|
# | |__| | . \| |____   ____) |  __/ (__| | |  __/ |_\__ \
#  \_____|_|\_\______| |_____/ \___|\___|_|  \___|\__|___/

echo "Fetching GKE secrets"

# Function to update or create a secret in GCP Secret Manager
update_or_create_secret() {
  local secret_name=$1
  local secret_value=$2

  if gcloud secrets describe "$secret_name" > /dev/null 2>&1; then
    # If the secret exists, check the latest version value
    existing_secret_value=$(gcloud secrets versions access latest --secret="$secret_name")

    if [[ "$existing_secret_value" == "$secret_value" ]]; then
      echo "The value of secret $secret_name is already up-to-date. Skipping update."
    else
      echo "Updating secret $secret_name."
      echo -n "$secret_value" | gcloud secrets versions add "$secret_name" --data-file=-
    fi
  else
    # If the secret does not exist, create it
    echo "Secret $secret_name does not exist. Creating a new secret."
    gcloud secrets create "$secret_name" --replication-policy="automatic"
    echo -n "$secret_value" | gcloud secrets versions add "$secret_name" --data-file=-
  fi
}

# Fetch Redis password from Kubernetes and generate the connection string
REDIS_PASSWORD=$(kubectl get secret redis -o jsonpath='{.data.redis-password}' | base64 --decode)
REDIS_URL="redis://default:$REDIS_PASSWORD@redis-master:6379"

# Update or create the Redis URL secret
update_or_create_secret "redis-url" "$REDIS_URL"

# Get IPs and update/create other secrets
update_or_create_secret "DOCUMENT_CHAT_URL" $(kubectl get service doc-chat-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')
update_or_create_secret "vertexai_followup" $(kubectl get service vertex-ai-followup-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')
update_or_create_secret "vertexai_citation" $(kubectl get service vertexai-citation-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')
update_or_create_secret "vertexai_python_url" $(kubectl get service vertexai-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')
update_or_create_secret "vertexai-summary" $(kubectl get service vertexai-summary-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')
update_or_create_secret "pdf_loadbalancer" $(kubectl get service pdflb -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}')

#   _____  _____ _____     _____ ______ _____ _____  ______ _______ _____ 
#  / ____|/ ____|  __ \   / ____|  ____/ ____|  __ \|  ____|__   __/ ____|
# | |  __| |    | |__) | | (___ | |__ | |    | |__) | |__     | | | (___  
# | | |_ | |    |  ___/   \___ \|  __|| |    |  _  /|  __|    | |  \___ \ 
# | |__| | |____| |       ____) | |___| |____| | \ \| |____   | |  ____) |
#  \_____|\_____|_|      |_____/|______\_____|_|  \_\______|  |_| |_____/ 
                                                                         
                                                                         
# Replace for vertexai-referer secret
echo "Adding WEBSITE_URL to GCP Secret named vertexai-referer"
SECRET_NAME="vertexai-referer"

echo "Checking if WEBSITE_URL is already present in the GCP Secret named $SECRET_NAME..."

# Ensure WEBSITE_URL is not empty
if [ -z "$WEBSITE_URL" ]; then
  echo "Error: WEBSITE_URL is empty. No update will be performed."
  exit 1
fi

# Retrieve the latest version of the secret and its data
LATEST_VERSION=$(gcloud secrets versions list "$SECRET_NAME" --sort-by='createTime' --limit=1 --format="value(name)")

if [ -z "$LATEST_VERSION" ]; then
  echo "No versions found for the secret $SECRET_NAME. Creating a new version."
  TMP_FILE=$(mktemp)
  echo -n "https://$WEBSITE_URL" > "$TMP_FILE"
  gcloud secrets versions add "$SECRET_NAME" --data-file="$TMP_FILE"
  rm "$TMP_FILE"
  echo "New version added to secret $SECRET_NAME."
else
  LATEST_VERSION_NUMBER=$(echo "$LATEST_VERSION" | awk '{print $1}')
  EXISTING_DATA=$(gcloud secrets versions access "$LATEST_VERSION_NUMBER" --secret="$SECRET_NAME")

  # Compare the existing data with the new data
  if [ "$EXISTING_DATA" == "$WEBSITE_URL" ]; then
    echo "The WEBSITE_URL is already present in the latest version. Skipping update."
  else
    echo "The WEBSITE_URL is not present. Creating a new version."
    TMP_FILE=$(mktemp)
    echo -n "$WEBSITE_URL" > "$TMP_FILE"
    gcloud secrets versions add "$SECRET_NAME" --data-file="$TMP_FILE"
    rm "$TMP_FILE"
    echo "New version added to secret $SECRET_NAME."
  fi
fi

echo "Proceeding to the next steps..."

#   _____ ____  _____   _____ 
#  / ____/ __ \|  __ \ / ____|
# | |   | |  | | |__) | (___  
# | |   | |  | |  _  / \___ \ 
# | |___| |__| | | \ \ ____) |
#  \_____\____/|_|  \_\_____/ 
                             
                             
echo "Replacing Values For Cors"
sed -i "s|REPLACE_WITH_WEBSITE_URL|https://$WEBSITE_URL|g" cors.json
gsutil cors set cors.json gs://$BUCKET_NAME
gsutil cors get gs://$BUCKET_NAME

#   _____ _                 _   _____
#  / ____| |               | | |  __ \
# | |    | | ___  _   _  __| | | |__) |   _ _ __
# | |    | |/ _ \| | | |/ _` | |  _  / | | | '_ \
# | |____| | (_) | |_| | (_| | | | \ \ |_| | | | |
#  \_____|_|\___/ \__,_|\__,_| |_|  \_\__,_|_| |_|


echo "Deploying file-upload-pubsub "
gcloud run deploy file-upload-pubsub --image=$FILE_UPLOAD_PUBSUB_ID --set-env-vars=batch_size=1,project_id=$PROJECT_ID  --platform managed  --vpc-connector=projects/$PROJECT_ID/locations/us-central1/connectors/disearch-vpc-connector --set-secrets=vertexai_python_url=vertexai_python_url:latest,metadata_cloud_fn=metadata_cloud_fn:latest,image_summary_cloud_fn=image_summary_cloud_fn:latest,APP_VERSION=APP_VERSION:latest --region=us-central1 --project=$PROJECT_ID --service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com --allow-unauthenticated --min-instances=1 --max-instances=2

echo "Deploying image-pubsub"
gcloud run deploy image-pubsub --image=$IMAGE_PUBSUB_ID --set-env-vars=image_subscription_id=image-subscription,project_id=$PROJECT_ID,batch_size=1,project_id=$PROJECT_ID  --platform managed  --vpc-connector=projects/$PROJECT_ID/locations/us-central1/connectors/disearch-vpc-connector --set-secrets=vertexai_python_url=vertexai_python_url:latest,metadata_cloud_fn=metadata_cloud_fn:latest,image_summary_cloud_fn=image_summary_cloud_fn:latest,APP_VERSION=APP_VERSION:latest --region=us-central1 --project=$PROJECT_ID --service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com --allow-unauthenticated --min-instances=1 --max-instances=2

echo "Deploying metadata-pubsub"
gcloud run deploy metadata-pubsub --image=$METADATA_PUBSUB_ID --set-env-vars=project_id=$PROJECT_ID,batch_size=1 --platform managed  --vpc-connector=projects/$PROJECT_ID/locations/us-central1/connectors/disearch-vpc-connector --set-secrets=vertexai_python_url=vertexai_python_url:latest,metadata_cloud_fn=metadata_cloud_fn:latest,image_summary_cloud_fn=image_summary_cloud_fn:latest,APP_VERSION=APP_VERSION:latest --region=us-central1 --project=$PROJECT_ID --service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com --allow-unauthenticated --min-instances=1 --max-instances=2

echo "Deploying pdf-convert-pubsub"
gcloud run deploy pdf-convert-pubsub --image=$PDF_CONVERT_PUBSUB_ID --set-env-vars=batch_size=1,project_id=$PROJECT_ID --platform managed  --vpc-connector=projects/$PROJECT_ID/locations/us-central1/connectors/disearch-vpc-connector --set-secrets=pdf_loadbalancer=pdf_loadbalancer:latest,APP_VERSION=APP_VERSION:latest --region=us-central1 --project=$PROJECT_ID --service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com --allow-unauthenticated --min-instances=1 --max-instances=2

echo "Deploying DiSearch Cloud Run"
gcloud run deploy disearch \
--image=$DISEARCH_IMAGE_ID \
--set-env-vars=ALLOWED_ORIGIN=$WEBSITE_URL --set-env-vars=appName=disearch --set-env-vars=schema=disearch --set-env-vars=AUTH_EMAIL=$DEFAULT_OWNER_EMAIL --set-env-vars=IS_PENSDOWN=false --set-env-vars=IS_CONTEXT=false \
--set-cloudsql-instances=$PROJECT_ID:us-central1:disearch-db \
--service-account=gke-sa@$PROJECT_ID.iam.gserviceaccount.com \
--set-secrets=service_key=service_key:latest,DB_USER=DB_USER:latest,GCP_BUCKET=GCP_BUCKET:latest,DB_HOST=DB_HOST:latest,DB_PASSWORD=DB_PASSWORD:latest,DOCUMENT_CHAT_URL=DOCUMENT_CHAT_URL:latest,LOG_INDEX=LOG_INDEX:latest,project_id=project_id:latest,vertex_ai_search_summary_url=vertexai-summary:latest,vertex_ai_followup_url=vertexai_followup:latest,IS_VERTEX_AI=IS_VERTEXAI:latest,vertex_ai_search_base_url=vertexai_citation:latest,vertex_ai_init_base_url=vertexai_python_url:latest,APP_VERSION=APP_VERSION:latest \
--no-cpu-boost \
--region=us-central1 \
--project=$PROJECT_ID

#  _____   ____  __  __          _____ _   _ 
# |  __ \ / __ \|  \/  |   /\   |_   _| \ | |
# | |  | | |  | | \  / |  /  \    | | |  \| |
# | |  | | |  | | |\/| | / /\ \   | | | . ` |
# | |__| | |__| | |  | |/ ____ \ _| |_| |\  |
# |_____/ \____/|_|  |_/_/    \_\_____|_| \_|
                                            
                                            
# Extract the domain from the URL
DOMAIN=$(echo $WEBSITE_URL | awk -F[/:] '{print $4}')

# Print the variables (optional)
echo "WEBSITE_URL: $WEBSITE_URL"
echo "DOMAIN: $DOMAIN"

echo "Domain Mapping on Managed Cloud RUN"
gcloud beta run domain-mappings create --service disearch --domain $WEBSITE_URL --region $REGION


#       _  ____  ____    ______ ____  _____    _      _      __  __   __  __  ____  _____  ______ _       _____ 
#      | |/ __ \|  _ \  |  ____/ __ \|  __ \  | |    | |    |  \/  | |  \/  |/ __ \|  __ \|  ____| |     / ____|
#      | | |  | | |_) | | |__ | |  | | |__) | | |    | |    | \  / | | \  / | |  | | |  | | |__  | |    | (___  
#  _   | | |  | |  _ <  |  __|| |  | |  _  /  | |    | |    | |\/| | | |\/| | |  | | |  | |  __| | |     \___ \ 
# | |__| | |__| | |_) | | |   | |__| | | \ \  | |____| |____| |  | | | |  | | |__| | |__| | |____| |____ ____) |
#  \____/ \____/|____/  |_|    \____/|_|  \_\ |______|______|_|  |_| |_|  |_|\____/|_____/|______|______|_____/ 
                                                                                                               
echo "Adding LLM Models on Cloud SQL Instance"
gcloud run jobs create llm-model-migration --image=$LLM_MODEL_IMPORT_ID \
  --vpc-connector=disearch-vpc-connector --set-cloudsql-instances=$PROJECT_ID:us-central1:disearch-db \
  --region=us-central1 --set-secrets=DB_HOST=DB_HOST:latest,DB_PASSWORD=DB_PASSWORD:latest \
  --project=$PROJECT_ID --service-account=terraform@$PROJECT_ID.iam.gserviceaccount.com

gcloud run jobs execute llm-model-migration --region us-central1
