# k8s-cups
Example of a [CUPS](https://www.cups.org/) print server from within [OpenShift](https://www.openshift.com/) or [Kubernetes](https://kubernetes.io/).

## About
This is a series of sample YAML files that stand up a CUPS print server running from within OpenShift or Kubernetes.  It uses the `quay.io/robbmanes/cups:latest` image for the CUPS server, which is built from `registry.fedoraproject.org/fedora-minimal`.  The [Dockerfile](Dockerfile) for this image can be found within this repository.

## Deployment
To deploy this example directly to your OpenShift or Kubernetes cluster do:
```
$ kubectl create -f cups-conf.yaml -f cups-files.yaml -f pod.yaml -f service.yaml
```

## Teardown
To remove this example from your cluster, do:
```
$ kubectl delete pods,jobs,svc,cm -l=app=cups
```
