## Command for listing enabled APIS...

    gcloud services list --enabled --project YOUR_PROJECT_ID


## Script for disabling the APIS

    #!/bin/bash
    
    # Check if project ID is provided
    if [ -z "$1" ]; then
        echo "Usage: $0 PROJECT_ID"
        exit 1
    fi
    
    PROJECT_ID=$1
    
    # Set the active project
    gcloud config set project "$PROJECT_ID"
    
    # List of APIs to disable
    apis=(
        "aiplatform.googleapis.com"           # Vertex AI API
        "analyticshub.googleapis.com"         # Analytics Hub API
        "apigateway.googleapis.com"           # API Gateway API
        "appenginereporting.googleapis.com"   # App Engine
        "artifactregistry.googleapis.com"     # Artifact Registry API
        "autoscaling.googleapis.com"          # Cloud Autoscaling API
        "bigquery.googleapis.com"             # BigQuery API
        "bigqueryconnection.googleapis.com"   # BigQuery Connection API
        "bigquerydatapolicy.googleapis.com"   # BigQuery Data Policy API
        "bigquerymigration.googleapis.com"    # BigQuery Migration API
        "bigqueryreservation.googleapis.com"  # BigQuery Reservation API
        "bigquerystorage.googleapis.com"      # BigQuery Storage API
        "certificatemanager.googleapis.com"   # Certificate Manager API
        "cloudapis.googleapis.com"            # Google Cloud APIs
        "cloudbuild.googleapis.com"           # Cloud Build API
        "cloudfunctions.googleapis.com"       # Cloud Functions API
        "cloudlatencytest.googleapis.com"     # Cloud Network Performance Monitoring API
        "cloudresourcemanager.googleapis.com" # Cloud Resource Manager API
        "cloudscheduler.googleapis.com"       # Cloud Scheduler API
        "cloudtrace.googleapis.com"           # Cloud Trace API
        "compute.googleapis.com"              # Compute Engine API
        "container.googleapis.com"            # Kubernetes Engine API
        "containerfilesystem.googleapis.com"  # Container File System API
        "containerregistry.googleapis.com"    # Container Registry API
        "dataflow.googleapis.com"             # Dataflow API
        "dataform.googleapis.com"             # Dataform API
        "datapipelines.googleapis.com"        # Data pipelines API
        "dataplex.googleapis.com"             # Cloud Dataplex API
        "datastore.googleapis.com"            # Cloud Datastore API
        "deploymentmanager.googleapis.com"    # Cloud Deployment Manager V2 API
        "dialogflow.googleapis.com"           # Dialogflow API
        "discoveryengine.googleapis.com"      # Discovery Engine API
        "dns.googleapis.com"                  # Cloud DNS API
        "documentai.googleapis.com"           # Cloud Document AI API
        "endpoints.googleapis.com"            # Google Cloud Endpoints
        "eventarc.googleapis.com"             # Eventarc API
        "eventarcpublishing.googleapis.com"   # Eventarc Publishing API
        "firebaserules.googleapis.com"        # Firebase Rules API
        "firestore.googleapis.com"            # Cloud Firestore API
        "gkebackup.googleapis.com"            # Backup for GKE API
        "gkeonprem.googleapis.com"            # GDC Virtual API
        "iam.googleapis.com"                  # Identity and Access Management (IAM) API
        "iamcredentials.googleapis.com"       # IAM Service Account Credentials API
        "iap.googleapis.com"                  # Cloud Identity-Aware Proxy API
        "language.googleapis.com"             # Cloud Natural Language API
        "logging.googleapis.com"              # Cloud Logging API
        "monitoring.googleapis.com"           # Cloud Monitoring API
        "networkconnectivity.googleapis.com"  # Network Connectivity API
        "networkmanagement.googleapis.com"    # Network Management API
        "notebooks.googleapis.com"            # Notebooks API
        "osconfig.googleapis.com"             # OS Config API
        "oslogin.googleapis.com"              # Cloud OS Login API
        "pubsub.googleapis.com"               # Cloud Pub/Sub API
        "run.googleapis.com"                  # Cloud Run Admin API
        "secretmanager.googleapis.com"        # Secret Manager API
        "servicecontrol.googleapis.com"       # Service Control API
        "servicemanagement.googleapis.com"    # Service Management API
        "servicenetworking.googleapis.com"    # Service Networking API
        "serviceusage.googleapis.com"         # Service Usage API
        "source.googleapis.com"              # Legacy Cloud Source Repositories API
        "sql-component.googleapis.com"        # Cloud SQL
        "sqladmin.googleapis.com"             # Cloud SQL Admin API
        "storage-api.googleapis.com"          # Google Cloud Storage JSON API
        "storage-component.googleapis.com"    # Cloud Storage
        "storage.googleapis.com"              # Cloud Storage API
        "storageinsights.googleapis.com"      # Storage Insights API
        "visionai.googleapis.com"             # Vision AI API
        "vpcaccess.googleapis.com"            # Serverless VPC Access API
    )
    
    # Loop through the APIs and disable each one
    for api in "${apis[@]}"; do
        echo "Disabling API: $api"
        gcloud services disable "$api" --force || echo "Failed to disable API: $api"
    done
    
## Assiging permissions to the file

      chmod +x script_for_disabling_api.sh
## Executing file and give project id as variable
        
        ./script_for_disabling_api.sh world-learning-400909

        ./script_for_disabling_api.sh PROJECT_ID
