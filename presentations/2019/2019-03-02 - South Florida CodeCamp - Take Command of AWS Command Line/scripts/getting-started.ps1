<#
Before you begin, create a new IAM user for AWSCLI, with enough rights
Note the access key and secret
See: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console
#>
exit #PREVENT F5

aws
aws --version
#note the various options 
aws help     
aws help topics  
aws help config-vars  

#configure, see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
aws configure help 
aws configure list
aws configure --profile david1


#profiles? 
aws configure list
aws configure get profile
cat ~/.aws/config




#IAM, Identity & Access Management
#HUGE TOPIC, see https://docs.aws.amazon.com/cli/latest/reference/iam

#get all users
aws iam list-users
#get my user info
aws iam get-user --output table

aws iam get-user 
#view --debug output
aws iam get-user --debug
#change the output format
aws iam get-user --output json
aws iam get-user --output table
aws iam get-user --output text



aws iam get-user --output table
aws iam get-account-summary --output table
#get aws account number with a --query
aws sts get-caller-identity 
aws sts get-caller-identity --output text --query 'Account'

aws configure get region