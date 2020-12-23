# Building on OpenShift Container Platform 4
If you don't want to use the previous directory's Dockerfile or the upstream quay.io image, then if you are using OpenShift 4 this example `buildConfig` can build you a Red Hat based image, using only Red Hat components.

Using this method requires an active subscription from Red Hat to function.  The instructions on how to best perform this are below, but are also talked about in more detail in [this documentation from Red Hat directly](https://docs.openshift.com/container-platform/4.6/builds/running-entitled-builds.html).

## Steps to Perform Local OpenShift Builds
- Make sure the `cups` namespace already exists from the previous directory:
```
$ oc create -f ../namespace.yaml
```

- Ensure you are in the `cups` project:
```
$ oc project cups
```

- From a Red Hat Enterprise Linux host (using RHEL8 in the below example), copy the secret file to the project (secret name will change per host):
```
$ oc create secret generic etc-pki-entitlement --from-file /etc/pki/entitlement/SOME_CERTIFICATE.pem --from-file /etc/pki/entitlement/SOME_KEY_FILE-key.pem
```

For the above step, note both the `*.pem` and `*-key.pem` files are necessary to properly entitle your build, so if you have multiple ensure you have a `--from-file` directive for *each* file.

- From a Red Hat Enterprise Linux host (using RHEL8 in the below example), copy subscription-manager files as `configMaps` to the project:
```
$ oc create configmap rhsm-conf --from-file /etc/rhsm/rhsm.conf
$ oc create configmap rhsm-ca --from-file /etc/rhsm/ca/redhat-uep.pem
```

- Assuming you are in the `ocp4-build` directory, create the entrypoint script `configMap` from the previous directory:
```
$ oc create configmap cups-entrypoint --from-file ../entrypoint.sh
```

- Create the destination `ImageStream`:
```
$ oc create -f is.yaml
```

- Create the `buildConfig`:
```
$ oc create -f buildconfig.yaml
```

- Create the `buildConfig`:
```
$ oc create -f buildconfig.yaml
```

- At this point, you should be able to launch a test pod using the image:
```
$ oc create -f ocp4-pod.yaml
```

## Verifying your Pod is Functional
Once you've completed the above steps, you can now access your pod running CUPS:
```
$ oc get pods
NAME           READY     STATUS      RESTARTS   AGE
cups-1-build   0/1       Completed   0          5m1s
ocp4-cups      1/1       Running     0          2m36s

$ oc exec -it ocp4-cups bash

[root@ocp4-cups /]# lpstat -t
scheduler is running
no system default destination
lpstat: No destinations added.
lpstat: No destinations added.
lpstat: No destinations added.
lpstat: No destinations added.

[root@ocp4-cups /]# lpadmin -p test -E

[root@ocp4-cups /]# lpstat -t
scheduler is running
no system default destination
device for test: ///dev/null
test accepting requests since Tue Dec 22 16:20:45 2020
printer test is idle.  enabled since Tue Dec 22 16:20:45 2020
```
