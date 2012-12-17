GRE340 Webapp
==============

GRE web-app for mock/practice tests.

## Deployment Instructions

The app has two deployed versions of the app on heroku.

1. gre340-staging.herokuapp.com [ staging-version ]

2. gre340-production.herokuapp.com [ production-version ]

#### "master" branch on GitHub deploys to "staging-version" on Heroku.

#### "staging" branch on GitHub deploys to "production-versio" on Heroku.

## Sample Workflow

When you clone the project from GitHub you will see 2 branches.

1. master
2. staging

- Add git remote for stashing & production app.

	git remote add gre340-staging git@heroku.com:gre340-staging.git
	git remote add gre340-production git@heroku.com:gre340-production.git

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