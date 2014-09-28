S3_BUCKET=rmcgibbo.org
PUBLIC=public

s3_upload:
	s3cmd sync $(PUBLIC)/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type