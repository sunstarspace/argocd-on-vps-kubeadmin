<br />

# **!!!! D R A F T** !!!

# **Installing and configuring ArgoCD on a Linux VPS Kubernetes cluster (kubeadmin).**

<br />

## Technologies used:

1. Terraform
2. Linux VPS (Virtual Private Server)
3. ArgoCD
4. Shell scripting

<br />

## Copy kubeconfig file from the Kubernetes control plane (existing ssh access to the Linux machine is needed).

Be ready to provide the following when executing the copying_kubeconfig.sh script:

 - Remote VPS IP
 - Remote VPS Port
 - username
 - path to the kubeconfig file
 - path to the local ssh private key

<br />

Make the copying_kubeconfig.sh file executable:
```
chmod +x copying_kubeconfig.sh
```

<br />

Execute the script and follow the steps:
```
./copying_kubeconfig.sh
```

<br />
.
.
.
.
.
.


<br />

###### **DISCLAIMER**
Please consult the official documentation before using.
NOBODY BUT YOU IS RESPONSIBLE FOR ANY USE OR DAMAGE THIS COMMANDS MAY CAUSE.
THIS IS INTENDED FOR EDUCATIONAL PURPOSES ONLY. USE AT YOUR OWN RISK.
