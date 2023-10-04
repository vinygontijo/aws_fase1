# Amazon Day 2 Amazon Elastic Kubernetes Service

```sh
# working directory
cd eks

# tag and build image
docker build .\
          -t carlosbpy/owshq-spark-py-delta:latest \
          -f Dockerfile

# push image to docker hub
docker push \
		carlosbpy/owshq-spark-py-delta:latest

# install helm chart spark-operator
kubectl create namespace spark
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
helm repo update
helm install spark spark-operator/spark-operator --namespace spark --set image.tag=v1beta2-1.3.2-3.1.1

# get pods in namespace spark
kubectl get pods -n spark

# expected output
NAME                                    READY   STATUS    RESTARTS   AGE
spark-spark-operator-57cb984996-sw4v8   1/1     Running   0          3s

## create rbac [role based access control]
# ClusterRoleBinding 
kubectl apply -f manifests/crb-spark.yaml -n spark

# create secrets
kubectl create secret -n spark generic aws-secret \
--from-literal=awsAccessKeyId=<AWS_ACCESS_KEY_ID> \
--from-literal=awsSecretAccessKey=<AWS_SECRET_ACCESS_KEY>

kubectl describe secrets aws-secret -n spark

# expected output
Name:         aws-secret
Namespace:    spark
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
awsAccessKeyId:      20 bytes
awsSecretAccessKey:  40 bytes

# apply manifest
kubectl apply -f manifests/sparkOperator/spark.yaml -n spark

# debugging
kubectl get pods -n spark -w

# ContainerCreating with driver
NAME                                                        READY   STATUS              RESTARTS   AGE
owshq-trn-cc-bg-aws-driver                                  0/1     ContainerCreating   0          4s
spark-spark-operator-57cb984996-sw4v8                       1/1     Running             0          88s

# Executor running
NAME                                          	   READY   STATUS    RESTARTS   AGE
owshq-spark-delta-driver-327ccf800588c602-exec-1   1/1     Running   0          13s
owshq-spark-delta-driver                      	   1/1     Running   0          21s
spark-spark-operator-57cb984996-sw4v8         	   1/1     Running   0          72m

# debugging
kubectl logs <spark-driver-pod> -n spark -f

# get results spark job
kubectl get sparkapplication -n spark

# expected output
NAME                  STATUS      ATTEMPTS   START                  FINISH                 AGE
owshq-trn-cc-bg-aws   COMPLETED   1          2022-04-07T19:38:05Z   2022-04-07T19:38:57Z   112s
```