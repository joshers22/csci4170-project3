export PROJECT_ID="csci4170-project3"
export REGION="us-east4"
export ZONE="us-east4-a"
export CLUSTER="jenkins-cd"
export AR_REPO="demo-repo"
export VM="jenkins-vm"
export IMAGE_BASE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/nyan"

# Blank until the IP is reserved and the Service exists. Re-source after those steps.
export JENKINS_IP="$(gcloud compute addresses describe jenkins-ip --region "$REGION" --project "$PROJECT_ID" --format='value(address)' 2>/dev/null)"
export LB_IP="$(kubectl get svc nyan -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)"
export JENKINS_URL="http://${JENKINS_IP}:8080/"
