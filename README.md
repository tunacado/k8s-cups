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

## Testing
A simple test job has been provided to check your service connectivity to the CUPS server.

To deploy the job, do:
```
$ kubectl create -f cups-test.yaml
```

Inspect it like so:
```
$ kubectl get jobs
NAME        COMPLETIONS   DURATION   AGE
cups-test   0/1           6s         6s

$ kubectl get pods
NAME              READY     STATUS      RESTARTS   AGE
cups              1/1       Running     0          29s
cups-test-2m8sw   0/1       Completed   0          19s
```

Inspect the pod it creates; success has a code of "200":
```
$ kubectl logs cups-test-2m8sw
200
```

Delete the job like so:
```
$ kubectl delete job cups-test
```
