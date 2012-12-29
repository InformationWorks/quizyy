GRE340 Webapp
==============

GRE web-app for mock/practice tests.

## Deployment Instructions

The app has two deployed versions of the app on heroku.

1. gre340-staging.herokuapp.com [ staging-version ]

2. gre340-production.herokuapp.com [ production-version ]

#### "staging" branch on GitHub deploys to "staging-version" on Heroku.

#### "master" branch on GitHub deploys to "production-version" on Heroku.

## Amazon S3 support

Configurations are used in the file "config/initializers/carrierwave.rb"

### Setup S3 config on Dev machine to use dev bucket.

Add below lines in the file "~/.bash_profile"

export GRE340_AWS_ACCESS_KEY_ID="key_goes_here"
export GRE340_AWS_SECRET_ACCESS_KEY="secret_key_goes_here"

Bucket name for development machine comes from the config file.  

### Setup S3 config on Heroku

Amazon S3 configuration for staging/production are set on heroku using below commands.

$ heroku config:add GRE340_AWS_ACCESS_KEY_ID="key_goes_here" --app gre340-staging
$ heroku config:add GRE340_AWS_SECRET_ACCESS_KEY="secret_key_goes_here" --app gre340-staging
$ heroku config:add GRE340_AWS_S3_BUCKET="bucket_name_goes_here" --app gre340-staging

Be careful when setting the bucketname for staging & production apps or I will kill you.

## Sample Workflow

When you clone the project from GitHub you will see 2 branches.

1. master
2. staging

- Add git remote for stashing & production app.

	1. git remote add gre340-staging git@heroku.gre340:gre340-staging.git
	2. git remote add gre340-production git@heroku.gre340:gre340-staging.git

     git@heroku.gre340 - "gre340" here is the account name for heroku accounts. 
     Heroku multiple account plugin: https://github.com/ddollar/heroku-accounts
    
     cat ~/.ssh/config 
	 Host heroku.iwadmin
	  HostName heroku.com
	  IdentityFile /Users/kshiti/.ssh/id_rsa_heroku_iwadmin_harshal_mac
	  IdentitiesOnly yes
	  User developer@informationworks.in
	
     Host heroku.gre340
	  HostName heroku.com
	  IdentityFile /Users/kshiti/.ssh/id_rsa_heroku_gre340_harshal_mac
	  IdentitiesOnly yes
	  User gre340.developer@gmail.com
	
- Merge any changes you want to push to the production to staging branch first.

- Push the local staging branch to master branch of "staging-version"

	git push gre340-staging staging:master
	
- Test the changes on gre340-staging.herokuapp.com

- If everything works fine, push the staging branch on Github for backup.

	git push origin staging:staging
	
- Merge the staging branch with the master branch.

- Push the local master branch to master branch of "production-version" 

- Test the changes on gre340-production.herokuapp.com

- If everything works fine, push the master branch on Github for backup.

	git push origin master:master	