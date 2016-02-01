## letsencrypt notes

### Renew cert
using https://github.com/dlapiduz/letsencrypt-s3front

```
sudo /usr/local/bin/letsencrypt --agree-tos -a letsencrypt-s3front:auth --letsencrypt-s3front:auth-s3-bucket rmcgibbo.org -i letsencrypt-s3front:installer --letsencrypt-s3front:installer-cf-distribution-id E1JZXZ946OZEEL -d rmcgibbo.org
```

### automation

Would be nice to have this in the travis-ci job, since it has the AWS credentials. w/o crontab, will
need some tricks to know when to renew, e.g.

```
http://www.shellhacks.com/en/HowTo-Check-SSL-Certificate-Expiration-Date-from-the-Linux-Shell
```