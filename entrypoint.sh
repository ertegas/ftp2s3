#!/usr/bin/env bash

# Entry point to mount s3fs filesystem before exec'ing command.

# Fail on all script errors
set -e

# Configuration checks
if [ -z "$S3_CREDS" ]; then
    echo "Error: S3_CREDS is not specified"
    exit 128
fi

echo "$S3_CREDS" > /etc/passwd-s3fs

# Configuration checks
if [ -z "$S3_URL" ]; then
    echo "Error: S3_URL is not specified"
    exit 128
fi

# Configuration checks
if [ -z "$S3_BUCKET_NAME" ]; then
    echo "Error: S3_BUCKET_NAME is not specified"
    exit 128
fi

# Configuration checks
if [ -z "$S3_MOUNTPOINT" ]; then
    echo "Error: S3_MOUNTPOINT not specified"
    exit 128
fi

# s3fs mount command
echo "${S3_BUCKET_NAME} ${S3_MOUNTPOINT} fuse.s3fs _netdev,allow_other,use_path_request_style,url=${S3_URL} 0 0" >> /etc/fstab
mount -a
date
ls ${S3_MOUNTPOINT}
proftpd --nodaemon --config /local/proftpd.conf
echo "Running command $@"
sleep 100000

exec "$@"
