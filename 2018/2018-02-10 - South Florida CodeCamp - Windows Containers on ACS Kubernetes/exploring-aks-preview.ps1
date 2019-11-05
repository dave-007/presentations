#What can we do with Azure managed Kubernetes cluster (AKS)?
az aks -h

az aks create -h
#no windows support (yet) :()

az aks install-connector -h
#if you are using Azure Container Instances (ACI) there is a provision to connect Kubernetes clusters into your ACI
#This approach is being abandoned, see Anthony Chu's blog post: https://anthonychu.ca/post/windows-containers-aci-connector-kubernetes/