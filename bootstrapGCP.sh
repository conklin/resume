
echo "visit https://github.com/apps/google-cloud-build and ensure google cloud build is configured"
echo "has cloud build been enabled ? y/n"
read -t 3 -n 1


echo "enabling cloud build apis"
gcloud services enable cloudbuild.googleapis.com

echo "Getting Terraform State Bucket"
BUCKET_URL=`gsutil ls gs:// | grep resume-terraform-state`
if [[ $BUCKET_URL == '' ]] ; then
    UNIQUE_NAME_POST_FIX=`uuidgen |  cut -f5 -d'-'  | tr '[:upper:]' '[:lower:]'`
    gsutil mb gs://resume-terraform-state-${UNIQUE_NAME_POST_FIX}
    BUCKET_URL=`gsutil ls gs:// | grep resume-terraform-state`
fi

echo "verify teraform builder exist"
TERRAFORM_IMAGE=`gcloud container images list --filter terraform --format="json"`
if [[ $TERRAFORM_IMAGE == '[]' ]] ; then
    echo "building terraform gcp community builder and publishing"
    mkdir -p tmp
    cd tmp
    git clone https://github.com/GoogleCloudPlatform/cloud-builders-community
    cd cloud-builders-community/terraform
    gcloud builds submit --config cloudbuild.yaml .
    cd ../../
fi

echo "add build triger to repo"
TRIGGER=`gcloud beta builds triggers list --filter='name:resume-triger' --format='value(name)'`
if [[ $TRIGGER == '' ]] ; then
    gcloud beta builds triggers create github --repo-name=resume --repo-owner=conklin --branch-pattern=".*" --build-config=cloudbuild.yaml --name="resume-triger"
fi