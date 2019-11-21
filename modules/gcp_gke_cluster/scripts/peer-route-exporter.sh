#!/bin/bash

# $1 = Project containing gke network
# $2 = Network Name

for peernet in $(gcloud beta compute networks --project "$1" peerings list --format="json" | jq -c '.[0].peerings |  map(select( (.name | contains("gke")) and ( .exportCustomRoutes == false  ) and ( .importCustomRoutes == false ) )) | map(.name)' | jq -r .[]) ; do
  gcloud beta compute networks --project "$1" peerings \
    update $peernet \
    --network "$2" \
    --export-custom-routes \
    --import-custom-routes
done
