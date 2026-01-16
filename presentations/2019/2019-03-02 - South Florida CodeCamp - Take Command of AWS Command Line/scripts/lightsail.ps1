<#
lightsail is the easiest way to spin up dev servers
Reference: LIGHTSAIL https://docs.aws.amazon.com/cli/latest/reference/lightsail/index.html
#>
exit #PREVENT F5


aws lightsail help
#What blueprints (aka images) are available?
aws lightsail get-blueprints 
aws lightsail get-blueprints --output table

#Note queries are picky, case sensitive
aws lightsail get-blueprints --query 'blueprints[*].[blueprintId,type,platform,name,version]'
aws lightsail get-blueprints --query 'blueprints[*].[blueprintId,type,platform,name,version]' --output table


#What bundles(aka sizes) are available?
aws lightsail get-bundles
aws lightsail get-bundles --query 'bundles[*].[bundleId,price,cpuCount,ramSizeInGb,diskSizeInGb]'
aws lightsail get-bundles --query 'bundles[*].[bundleId,price,cpuCount,ramSizeInGb,diskSizeInGb]' --output table
aws lightsail get-bundles --query 'bundles[*].[bundleId,price,cpuCount,ramSizeInGb,diskSizeInGb]' --output table

#what availability zones are available?
aws lightsail get-regions --include-availability-zones
aws lightsail get-regions --include-availability-zones --query 'regions[*].[name,availabilityZones]'
aws lightsail get-regions --include-availability-zones --query 'regions[*].[availabilityZones[*][zoneName,state]]'

#need keypair to access linux vms
#create the keypair, output the key and save to file
aws lightsail create-key-pair --key-pair-name dave-lightsail --query 'privateKeyBase64' --output text `
    | out-file -encoding ascii -filepath ~\.ssh\dave-lightsail-keypair.pem 
#view private key, USE CAUTION!
cat ~\.ssh\dave-lightsail-keypair.pem

aws lightsail get-key-pairs

#create linux vm
aws lightsail create-instances `
    --instance-names dev1 `
    --blueprint-id ubuntu_18_04 `
    --bundle-id nano_2_0 `
    --key-pair-name dave-lightsail `
    --availability-zone us-east-2a `
    --tags 'key=Environment, value=Dev' --debug


#create windows vm, let lightsail manage password
aws lightsail create-instances `
    --instance-names dev2 `
    --blueprint-id windows_server_2016_2019_02_09 `
    --bundle-id nano_win_2_0  `
    --availability-zone us-east-2a `
    --tags 'key=Environment, value=Dev' --debug


#how to access the windows VM, what's the password?
aws lightsail get-instance-access-details --instance-name dev2

#see lightsail vms
aws lightsail get-instances
aws lightsail get-instances --query 'instances[*][name,blueprintName,hardware.cpuCount,hardware.ramSizeInGb,state.name]' --output table

#cleanup
aws lightsail delete-instance --instance-name dev1
aws lightsail delete-instance --instance-name dev2
aws lightsail delete-key-pair --key-pair-name 'dave-lightsail'