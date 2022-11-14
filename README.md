# Git Partition Sync - Producer
Uploads encrypted/zipped latest versions of target GitLab projects to s3 bucket.  
This works in tandem with [gitlab-sync-s3-pull](https://github.com/app-sre/git-partition-sync-consumer) to sync GitLab instances in isolated environments.

[age](https://github.com/FiloSottile/age) x25519 format keys are utilized.

![gitlab-sync-diagram](gitsync-diagram.png)

## Environment Variables

### Required
* AWS_ACCESS_KEY_ID - s3 CRUD permissions required
* AWS_SECRET_ACCESS_KEY
* AWS_REGION
* AWS_S3_BUCKET - the name. not an ARN
* GITLAB_BASE_URL - GitLab instance base url. Ex: https://gitlab.foobar.com
* GITLAB_USERNAME
* GITLAB_TOKEN - repository read permission required
* GRAPHQL_SERVER - url to graphql server for querying
* PUBLIC_KEY - value of x25519 format public key. See [age encryption](https://github.com/FiloSottile/age#readme)

### Optional
* GRAPHQL_QUERY_FILE - absolute path to graphql query file. defaults to `/query.graphql`
* GRAPHQL_USERNAME
* GRAPHQL_PASSWORD
* RECONCILE_SLEEP_TIME - time between runs. defaults to 5 minutes (5m)
* WORKDIR - local directory where io operations will be performed

## Run

```
docker run -t \
    -e GRAPHQL_QUERY_FILE=$GRAPHQL_QUERY_FILE \
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
    quay.io/app-sre/git-partition-sync-producer:latest -dry-run=true -run-once=true
```

## Uploaded s3 Object Key Format
Uploaded keys are base64 encoded. Decoded, the key is a json string with following structure:
```
{
  "group":"some-gitlab-group",
  "project_name":"some-gitlab-project",
  "commit_sha":"full-commit-sha",
  "branch":"master"
}
```
**Note:** the values within each json will mirror values for each `destination` defined within config file (exluding `commit_sha` which is the latest commit pulled from `source`)