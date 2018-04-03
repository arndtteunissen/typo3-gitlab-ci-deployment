# TYPO3 deployment script for GitLab CI

This is an example script for our GitLab deployment.

This script is based on our companys TYPO3 distribution. 
It contains four stages:

* Test
* Build
* Deploy
* Warmup

This script will automatically deploy new releases to the staging
server when changes get pushed into master. To setup a deployment
to production, you have to merge it into the production branch.
This is necessary because the production deployment contains tasks
in multiple stages. GitLab will run every task that is not marked
with manual trigger even if it depends on a task, that needs to be 
triggered manually.