#!/bin/sh

# This script creates backups for a MySQL database and a root directory in the filesystem, in a scheduled manner.

# GCLOUD_BUCKET: environment variable representing the name of bucket in Google Cloud Storage
# GCLOUD_PROJECT_NAME: environment variable representing the name of project where the bucket is located in Google Cloud. The JSON file must contain the credentials for a service account in Google Cloud, with admin permissions over the bucket.
# MYSQL_DATABASE: environment variable representing the name of the database used to connect to the MySQL server
# MYSQL_HOST: environment variable representing the name of server where the MySQL server is located
# MYSQL_PASSWORD: environment variable representing the password used to connect to the MySQL server
# MYSQL_USER: environment variable representing the user connecting to the MySQL server

echo "Creating backup of the MySQL database"
now=$(date +"%Y%m%d_%H%M%S")
backupFileName="/backups-sql/${MYSQL_DATABASE}_${now}"
dumpFile="${backupFileName}.sql"
compressedFile="${backupFileName}.tar.gz"
/usr/bin/mysqldump --opt -h "${MYSQL_HOST}" -u"${MYSQL_USER}" -p ${MYSQL_PASSWORD} "${MYSQL_DATABASE}" > "${dumpFile}"
tar -czvf ${compressedFile} ${dumpFile}
rm -f ${dumpFile}
echo "Backup of the MySQL database created: $now"

gcloud config set project ${GCLOUD_PROJECT_NAME}
gcloud auth activate-service-account --key-file=/${GCLOUD_PROJECT_NAME}.json --project=${GCLOUD_PROJECT_NAME}

echo "Uploading database backups"
gsutil rsync -r /backups-sql gs://${GCLOUD_BUCKET}/sql
echo "Uploading filesystem backups"
gsutil rsync -r /backups-filesystem gs://${GCLOUD_BUCKET}/files