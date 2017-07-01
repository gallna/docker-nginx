#!/usr/bin/env bash

test -z "${AWS_S3_PREFIX}" && export AWS_S3_PREFIX=""
test -z "${AWS_REGION}" && { echo >&2 "Fatal: Missing required AWS_REGION;"; exit 1; }
test -z "${AWS_S3_BUCKET}" && { echo >&2 "Fatal: Missing required AWS_S3_BUCKET;"; exit 1; }
test -z "${AWS_ACCESS_KEY_ID}" && { echo >&2 "Fatal: Missing required AWS_ACCESS_KEY_ID;"; exit 1; }
test -z "${AWS_SECRET_ACCESS_KEY}" && { echo >&2 "Fatal: Missing required AWS_SECRET_ACCESS_KEY;"; exit 1; }

keys=$($(dirname $0)/generate_signing_key.py --region "${AWS_REGION}" --secret-key "${AWS_SECRET_ACCESS_KEY}")
export AWS_SIGNING_KEY=$(sed '2d' <<< "$keys")
export AWS_KEY_SCOPE=$(sed '1d' <<< "$keys")

envsubst "$(printf '${%s} ' $(env | grep -o "AWS_[^=]*"))" <<'EOF' | tee $(dirname $(dirname $0))/conf.d/default.conf
server {
    listen 80;
    resolver 8.8.8.8;

    location = /favicon.ico {
      root /var/www/public;
      try_files $uri =404;
    }

    location = / {
      if ($is_args = "") { set $prefix ?prefix=${AWS_S3_PREFIX}; }
      proxy_pass https://${AWS_S3_BUCKET}.s3.amazonaws.com$prefix;
      xslt_types application/xhtml+xml text/html application/xml;
      xslt_stylesheet xslt/s3.xslt;
    }

    location / {
      aws_s3_bucket ${AWS_S3_BUCKET};
      aws_access_key ${AWS_ACCESS_KEY_ID};
      aws_signing_key ${AWS_SIGNING_KEY};
      aws_key_scope ${AWS_KEY_SCOPE};
      aws_sign;
      proxy_pass https://${AWS_S3_BUCKET}.s3.amazonaws.com;
    }
}
EOF

nginx -g "daemon off;"
