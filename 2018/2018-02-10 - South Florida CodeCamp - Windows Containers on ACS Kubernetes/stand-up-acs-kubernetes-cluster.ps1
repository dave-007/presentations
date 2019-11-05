<#
PURPOSE: Script for South Florida CodeCamp 2018 to demonstrate Azure Container Service with Kubernetes and Windows



USAGE:
Run form VSCODE in PowerShell terminal, run indiviual lines with F8

REFERENCES:
http://www.fladotnet.com/codecamp
See also .\url-reference.md

AUTHOR:
David Cobb david@davidcobb.net
#>

throw "please don't press F5!"



#manage your azure account in azure cli, login to the right account for you!
az account clear
az account list
az account set --subscription '100dollar'
az login
az account show

#MAKE AN SSH KEY, public and private key file, password optional
#see url-reference.md for how to create SSH keys
#run next line from command line and follow prompts, doesn't work within vscode powershell terminal
ssh-keygen -t rsa -b 2048
#view key files
$myWorkingFolder = 'C:\Users\David\Documents\_projects\CodeCamp'

#NOTE: There is an alternative to creating your own keys.
#You can create your ACS Kubernetes cluster with a --generate-ssh-keys parameter, and it will create the ssh keys for you.
#I chose to manage my SSH keys explicitly to avoid confusion later. This is hard won knowledge. :)

ls $myWorkingFolder
#Store the paths to your public and private keys, know which is which!
$pathToSSHPublicKeyFile = "C:\Users\David\Documents\_projects\CodeCamp\codecamp-acs-key_rsa.pub"
#This private key is THE KEY to accessing your cluster. Don't lose it, and protect it!
$pathToSSHPrivateKeyFile = "C:\Users\David\Documents\_projects\CodeCamp\codecamp-acs-key_rsa"

#CREATE A NEW RESOURCE GROUP FOR THE ACS CLUSTER
#Nothing else should be added to this resource group
#see existing resource groups
az group list -o table
#available locations in Azure
az account list-locations -o table
#create the group, command returns json, hold result in a variable to use later
#choose your own name and location
az group create --name rg-acs2-codecamp --location eastus2
$newGroup = az group show --name rg-acs-codecamp | ConvertFrom-Json
$newGroup.id

#CREATE A SERVICE ACCOUNT FOR ACS with contributor rights on that group
#put result in a variable with ConvertFrom-Json for easier access
#makes working with AZCLI much easier
$newServiceAccount = az ad sp create-for-rbac --role="Contributor" --scopes=${newGroup.id} | ConvertFrom-Json
$newServiceAccount

#CREATE ACS CLUSTER
#setup some variables
$ACSClusterName = 'acs-codecamp'
$windowsPassword = '$UP3RS3CR3+43210' #be smart and change this password


#review command options
az acs -h
az acs create -h
#Note the --verbose, --debug options, useful to look under the hood. 
#Start with --verbose, as --debug can be a little overwhelming
#Note the --validate option, verify your command before running it!

#validate!
az acs create --name $ACSClusterName --resource-group $newGroup.name --orchestrator-type kubernetes --windows --admin-password $windowsPassword --agent-count 1 --service-principal $newServiceAccount.appId --client-secret $newServiceAccount.password --ssh-key-value $pathToSSHPublicKeyFile --validate --verbose

#create your new Azure ACS Kubernetes Cluster for Windows Containers!
az acs create --name $ACSClusterName --resource-group $newGroup.name --orchestrator-type kubernetes --windows --admin-password $windowsPassword --agent-count 1 --service-principal $newServiceAccount.appId --client-secret $newServiceAccount.password --ssh-key-value $pathToSSHPublicKeyFile --debug

#May take 10-20 minutes to run..

#hopefull that succeeds, can review with az acr show --name ...
az acs show --name $ACSClusterName --resource-group $newGroup.name

$newACSCluster = az acs show --name $ACSClusterName --resource-group $newGroup.name | ConvertFrom-Json
$newACSCluster


#REVIEW YOUR NEW ACS CLUSTER
#see the resources within your resource group
az resource list --resource-group $newGroup.name -o table
#Note that you're only paying for the resources the VMs in the cluster use
#You can shut down & deallocate these to save on costs


az acs kubernetes -h
#install the kubectl program if not yet installed
#might need admin rights to install, can install to alternate location

az acs kubernetes install-cli -h
az acs kubernetes install-cli
#add kubectl to your windows path if needed.
setx path "%path%;C:\Program Files (x86)\"
kubectl -h
kubectl version
#ACCESS YOUR ACS CLUSTER FROM KUBECTL
#NOTE: Managing access to Kubernetes clusters can be tricky, this approach may make it easier for you.

#kubernetes uses a config file to manage access to kubernetes clusters. 
#Config files can contain access to multiple Kubernetes clusters
#Kubectl looks for an environment variable KUBECONFIG for the path to the config file(s), has a default value
Get-ChildItem env:\k*
#I want to keep this config separate from other kubectl config files, so I'll change this KUBECONFIG environment variable
$myKUBECONFIGPath = 'C:\Users\David\Documents\_projects\CodeCamp\KUBECONFIG'
$env:KUBECONFIG = $myKUBECONFIGPath
#Note this environment variable change only lasts for the session, use another approach to change it permanently
#verify it is set
Get-ChildItem env:\k*
#Run kubectl commands before connecting to cluster, verify not connected yet
kubectl version
kubectl cluster-info

#Get credentials from your newly created ACS Kubernetes cluster and install them in the kubernetes config 
az acs kubernetes get-credentials -h
#run with --debug, as you may need to troubleshoot
az acs kubernetes get-credentials --name $newACSCluster.name --resource-group $newGroup.name --ssh-key-file $pathToSSHPrivateKeyFile --file $myKUBECONFIGPath --debug
#Verify access to the kubernetes cluster
kubectl version
kubectl cluster-info
#result should show the public urls for your acs kubernetes cluster, starting with 'Kubernetes master is running at....'
#if so, SUCCESS! You've provisioned an Azure Container Servers Kubernetes Cluster with Windows Containers! Give yourself a raise.

#if not, troubleshoot the common issues (parameter values, KUBECONFIG environment variable, SSH private key), or see the links in url-reference.md for guidance!

#to access the cluster you need access to the private key you generated earlier
az acs kubernetes browse -h
az acs kubernetes browse --name $newACSCluster.name --resource-group $newGroup.name --ssh-key-file $pathToSSHPrivateKeyFile --debug
#dont forget to add a slash '/' after the url in browser!
#this command ties up your terminal, so create a script file to start a new window
#see kube-browse.ps1 for an example




#OPTIONALLY, create an Azure Container Registry (ACR) and grant the service account Reader rights to it.
#Instead, you could access docker hub or other container registry instead

#create the Azure Container Registry
$newACRName = 'davidacr'
az acr -h
az acr create -h
az acr create --name $newACRName --resource-group $newGroup.name --sku Basic --admin-enabled
$newAcr = az acr show --name $newACRName | ConvertFrom-Json
$newAcr

#grant your ACS service account rights to read from it
az role assignment -h
az role assignment create -h
az role assignment create --assignee $newServiceAccount.appId --role Reader --scope $newAcr.id

#see the service account's permissions
az role assignment list  -h
az role assignment list --assignee $newServiceAccount.appId 
az role assignment list --assignee $newServiceAccount.appId --scope $newAcr.id




#TEARDOWN
#if you want to delete this acs cluster once you're done with it
az acs delete -h #just add your cluster name and resource group
#if that seems to easy to do, have a look at adding a CannotDelete lock
az lock create -h

#presentation fix for when vscode powershell terminal changes the foreground text to red after an error
$host.UI.RawUI.ForegroundColor = 'white'