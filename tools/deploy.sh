#!/bin/bash
source activate py27
pip install s3cmd
s3cmd --guess-mime-type sync $(OUTPUTDIR)/ s3://$(S3_BUCKET) --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY
