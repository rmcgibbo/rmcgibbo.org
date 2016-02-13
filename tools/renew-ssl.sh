#!/bin/bash
RENEW_CERTIFICATE_WITHIN_DAYS="100"
SERVER_DOMAIN="rmcgibbo.org"
CLOUDFRONT_DISTRIBUTION_ID="E1JZXZ946OZEEL"
S3_BUCKET_NAME="rmcgibbo.org"

# difference between two dates
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 ))
}

# get the end date of the SSL cert on rmcgibbo.org
CERT_END_DATE=$(echo | openssl s_client -servername $SERVER_DOMAIN -connect $SERVER_DOMAIN:443 2>/dev/null | \
    openssl x509 -noout -dates | \
    grep notAfter | \
    cut -d= -f2)

# how many remaining valid days
DAYS_REMAINING=$(datediff "$CERT_END_DATE" now)

if [ "$DAYS_REMAINING" -lt "$RENEW_CERTIFICATE_WITHIN_DAYS" ]; then
    echo "Renewing SSL certificate!"
    source activate py27
    conda install --yes botocore boto3 zope.interface pyopenssl psutil pytz cryptography werkzeug mock
    pip install letsencrypt==0.4 letsencrypt-s3front==0.1.3
    LETSENCRYPT=$(which letsencrypt)
    sudo ${LETSENCRYPT} --agree-tos -a letsencrypt-s3front:auth \
        --letsencrypt-s3front:auth-s3-bucket $S3_BUCKET_NAME \
        -i letsencrypt-s3front:installer \
        --letsencrypt-s3front:installer-cf-distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
        -d $SERVER_DOMAIN
    cat letsencrypt.log
fi

