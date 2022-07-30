# gcloud-backuper

This docker image bundles a few backup tools to support creating a backup experience when creating backups.

The backups will be created using `cron`, so it's a responsibility of the consumer adding the scheduled executions to crontab.

## Supported backup tools

- MySQL client for SQL dumps.
- Google Cloud SDK, to support using `gsutil` to upload files to Google Cloud Storage.

## Cross-compilation

```shell
docker buildx build --platform linux/amd64 --build-arg OS_ARCHITECTURE=x86_64--tag mdelapenya/gcloud-backuper:1.1.0 .
docker buildx build --platform linux/arm64 --build-arg OS_ARCHITECTURE=arm --tag mdelapenya/gcloud-backuper:1.1.0-arm64 .
```

## Example

The [example app](./example) uses docker-compose to orchestrate the deployment of the backup tool alongside a web application and database to create backups for them.
