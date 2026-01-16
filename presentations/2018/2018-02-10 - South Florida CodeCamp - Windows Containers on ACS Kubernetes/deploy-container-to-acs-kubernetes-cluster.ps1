#verify access to the cluster
kubectl version
kubectl cluster-info

#download a sample yaml file
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/WebServer.yaml -O win-webserver.yaml
notepad .\win-webserver.yaml

#deploy new container to the cluster using the yaml file
kubectl apply -h
kubectl apply -f win-webserver.yaml
#observe the status of deployed pods
kubectl get pods -o wide
#once deployed, while waiting for that public IP, login interactively to the pod using the name from previous command
kubectl exec -it win-webserver-276471289-d4k8f powershell
#some commands to run in the interactive session:
Get-ChildItem Env:\
Ping google.com
#type exit or control-c to quit
Ex
#observe the services, what IP and ports are listening?
kubectl get svc

#wait for the pod to get an IP, can take a few minutes
kubectl get pods -w -o wide
#once the pod has  public IP and port, see what it returns using curl (if installed) or control-click link to view inthe web browser
curl http://40.79.68.121 #change to correct IP
#alternate
Invoke-WebRequest -Uri http://40.79.68.121 #change to correct IP
