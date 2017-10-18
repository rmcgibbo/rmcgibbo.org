#!/bin/bash
OUTPUTDIR=output
S3_BUCKET=rmcgibbo.org

source activate py27
# pip install s3cmd
# Until https://github.com/s3tools/s3cmd/issues/887 is released,
# post v2.0.0
pip install git+git://github.com/s3tools/s3cmd.git


s3cmd sync ${OUTPUTDIR}/ s3://${S3_BUCKET} \
  --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY \
  --acl-public --delete-removed \
  --guess-mime-type --no-mime-magic --no-preserve --cf-invalidate
