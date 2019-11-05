<#
sns is Amazon's simple notification service. 
Reference: S3 https://docs.aws.amazon.com/cli/latest/reference/sns
Example: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/US_SetupSNS.html
#>
exit #PREVENT F5
aws sns help
aws sns list-subscriptions

#create topic, hold output in variable
$topic = aws sns create-topic --name cloud-notify | ConvertFrom-Json
$topic.TopicArn
$myEmail = 'david@davidcobb.net'
#subscribe 
aws sns subscribe --topic-arn $topic.TopicArn --protocol email --notification-endpoint $myEmail  #actual email address here.


#confirm in your email client then...

$subscriptions = aws sns list-subscriptions  | ConvertFrom-Json
$subscriptions.Subscriptions[0].SubscriptionArn
#send a message to the topic

aws sns publish --message "Does this stuff work?" --topic $topic.TopicArn


#check email client

#works!


#cleanup
aws sns delete-topic --topic $topic.TopicArn
aws sns unsubscribe --subscription-arn $subscriptions.Subscriptions[0].SubscriptionArn