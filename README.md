Quizyy
==============

## Deployment Instructions

* "ashram" branch is used to deploy for ashram.quizyy.com
* Use cap deploy to deploy "ashram" branch from Github.

## Amazon S3 support

Configurations are used in the file "config/initializers/carrierwave.rb"

### Setup S3 config.

* Add values relavent for environment.(Dev bucket & Prd bucket)
* Add below lines in the file "~/.bash_profile"

export ASHRAM_QUIZYY_AWS_ACCESS_KEY_ID="key_id"
export ASHRAM_QUIZYY_AWS_SECRET_ACCESS_KEY="secret_key"
export ASHRAM_QUIZYY_AWS_S3_BUCKET_URL="https://s3.amazonaws.com/ashram-quizyy-dev"
export ASHRAM_QUIZYY_AWS_S3_BUCKET="ashram-quizyy-dev"