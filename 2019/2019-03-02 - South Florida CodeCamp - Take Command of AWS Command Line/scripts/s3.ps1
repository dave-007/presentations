<#
s3 is Amazon's simple storage service. 
Reference: S3 https://docs.aws.amazon.com/cli/latest/reference/s3/index.html
S3API https://docs.aws.amazon.com/cli/latest/reference/s3api/index.html
S3 Website Endpoints
https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteEndpoints.html
#>
exit #PREVENT F5

aws s3 help
aws s3 ls
aws s3 website help

#make a bucket for a website
aws s3 mb s3://dave-aws-site-ff --region us-east-2
#list my aws s3 buckets
aws s3 ls

#try to access bucket over https, public access denied by default 
Invoke-WebRequest http://dave-aws-site-ff.s3.amazonaws.com/
#website not configured yet
Invoke-WebRequest http://dave-aws-site-ff.s3-website.us-east-2.amazonaws.com/

#upload a web page
aws s3 cp ../html/index.html s3://dave-aws-site-ff
aws s3 ls s3://dave-aws-site-ff

#try to access html file, public access denied by default 
Invoke-WebRequest http://dave-aws-site-ff.s3.amazonaws.com/index.html


#enable website
aws s3 website help
aws s3 website s3://dave-aws-site-ff --index-document index.html
#verify website enabled
aws s3api get-bucket-website --bucket dave-aws-site-ff 

#grant rights
#refer https://stackoverflow.com/questions/41325740/aws-s3-permissions-error-with-put-bucket-acl
#check permissions
aws s3api list-buckets --region us-east-2 

#see default s3 permissions
aws s3api get-bucket-acl --bucket dave-aws-site-ff
aws s3api get-object-acl --bucket dave-aws-site-ff --key index.html

#grant public read access
aws s3api put-bucket-acl --bucket dave-aws-site-ff --acl public-read 
aws s3api put-object-acl --bucket dave-aws-site-ff --key index.html --acl public-read 
#see json skeleton, useful to customize permissions
aws s3api put-bucket-acl --bucket dave-aws-site-ff --generate-cli-skeleton 

#see updated s3 permissions
aws s3api get-bucket-acl --bucket dave-aws-site-ff
aws s3api get-object-acl --bucket dave-aws-site-ff --key index.html


#test it
#bucket url is not same as the website url
#refer to https://stackoverflow.com/a/24377823/2934158
#bucket url
Invoke-WebRequest http://dave-aws-site-ff.s3.amazonaws.com
#website url to html file
Invoke-WebRequest http://dave-aws-site-ff.s3-website.us-east-2.amazonaws.com/
#website url to default document
Invoke-WebRequest http://dave-aws-site-ff.s3-website.us-east-2.amazonaws.com/index.html



#S3 cleanup
<#
aws s3 rb s3://dave-aws-site-ff --force
#>