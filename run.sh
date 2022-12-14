#! /bin/bash

podman run -t --net=host \
    -e GRAPHQL_GLSYNC_QUERY_FILE=$GRAPHQL_GLSYNC_QUERY_FILE \
    -e GRAPHQL_SERVER=$GRAPHQL_SERVER \
    -e GRAPHQL_USERNAME=$GRAPHQL_USERNAME \
    -e GRAPHQL_PASSWORD=$GRAPHQL_PASSWORD \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_REGION=$AWS_REGION \
    -e AWS_S3_BUCKET=$AWS_S3_BUCKET \
    -e GITLAB_BASE_URL=$GITLAB_BASE_URL\
    -e GITLAB_USERNAME=$GITLAB_USERNAME \
    -e GITLAB_TOKEN=$GITLAB_TOKEN \
    -e PUBLIC_KEY=$PUBLIC_KEY \
    -e RECONCILE_SLEEP_TIME=$RECONCILE_SLEEP_TIME \
    -e WORKDIR=$WORKDIR \
    quay.io/app-sre/git-partition-sync-producer:latest -dry-run=true -run-once=false
