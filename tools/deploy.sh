#!/bin/bash
OUTPUTDIR=output
S3_BUCKET=rmcgibbo.org

source activate py27
pip install s3cmd

s3cmd sync ${OUTPUTDIR}/ s3://${S3_BUCKET} \
  --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY \
  --acl-public --delete-removed \
  --guess-mime-type --no-mime-magic --no-preserve --cf-invalidate
