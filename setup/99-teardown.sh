#!/usr/bin/env bash
source "$(dirname "$0")/00-env.sh"

# The Service first: its load balancer lives outside the cluster.
kubectl delete svc nyan --ignore-not-found
gcloud container clusters delete "$CLUSTER" --zone "$ZONE" --quiet
gcloud compute instances delete "$VM" --zone "$ZONE" --quiet
gcloud compute firewall-rules delete jenkins-ui jenkins-agents --quiet
gcloud compute addresses delete jenkins-ip --region "$REGION" --quiet

# The webhook points at an IP that no longer exists.
gh api repos/joshers22/csci4170-project3/hooks --jq '.[].id' | while read -r id; do
  gh api -X DELETE "repos/joshers22/csci4170-project3/hooks/$id"
done

gcloud container clusters list
gcloud compute instances list
