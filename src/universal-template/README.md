# Universal helm chart for rolling out difference services
## About helm-chart
This universal helm chart template is designed to simplify rolling out simple releases and speed up the helm implementation process. There is no need to write new charts for each microservice, you can use one by changing only values.yaml<br></br>
As an example, gitlab-ci will be used to use and integrate the helm chart.

## How to use it
### Simple values for `deployment` with `configMap`
```yaml
# An example of a fully described value file for describing the simplest release
# deployment, service, login, configmap, secret
---
# Tag for all default images
version: "latest"
# Anchors with ports of your services can be installed here for reuse
service_port_http: &service_port_http 80
service_metrics_port: &service_metrics_port 9090

# Applications - are a logical group for a microservice that includes
# deployment, tests, service, ingress, configmap, secret
applications:
  - name: app1
    # Enabling default tests for service and ingress
    tests:
      service: true
      virtualservices: true
    # Description of the deployment
    deployment:
      replicas: 1
      # Connecting the sidecar of the jaeger-agent container
      otlp:
        enabled: false
        grpcEndpoint: {}
      # Collection of microservice metrics in prometheus via prometheusOperator
      prometheus:
        enabled: true
        # The default metrics collection path is "/metrics"
        # path: "/metrics"
      image:
        # Image Link
        repository: group/image
        version: "1.0.0"
        # Secret name with dockerconfig (for private registry)
        pullsecrets: secret-registry-user
        # `IfNotPresent` - only if the image is missing locally
        # `Always` - the image is pumped out every time the hearth is started
        # `Never` - it is never pumped out, only local images
        imagePullPolicy: IfNotPresent
        # If it is necessary to predefine or replace the commands/arguments
        # commands:
        #   - bash
        # args:
        #   - c
        #   - env
      strategy:
        type: RollingUpdate
      # Container environment variables
      envs:
        LOG_LEVEL: info
      # Environment variables to extract from the secret
      envsSecret: []
      #  - name: SECRET_USERNAME
      #    keySecret: username
      podAnnotations:
        # An annotation that calculates the checksum of your values.yaml file
        # Guarantees a restart of the hearth if values.yaml has changed
        checksum/values.yaml: "helm/values.yaml"
      probes:
        livenessProbe:
          httpGet:
            path: /health/liveness
            port: *service_metrics_port
          initialDelaySeconds: 30
          periodSeconds: 5
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health/readiness
            port: *service_metrics_port
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
      # Redefine resource quotas
      resources:
        requests:
          memory: "256Mi"
          cpu: "250m"
        limits:
          memory: "512Mi"
          cpu: "500m"
      # Redefine the affinity of the pod
      affinity: {}
      # nodeAffinity:
      #   requiredDuringSchedulingIgnoredDuringExecution:
      #     nodeSelectorTerms:
      #       - matchExpressions:
      #           - key: kubernetes.io/e2e-az-name
      #             operator: In
      #             values:
      #               - e2e-az1
      #               - e2e-az2
      # Redefine the nodeSelector of the pod
      nodeSelector: {}
      # Redefine the tolerations of the pod
      tolerations: []
    # Description of the Service
    service:
      - name: http
        port: *service_port_http
        protocol: TCP
        targetPort: *service_port_http
      - name: http-metrics
        port: *service_metrics_port
        protocol: TCP
        targetPort: *service_metrics_port

    # Description of the Ingress
    ingress:
      - name: http
        # apiVersion: networking.k8s.io/v1
        # kind: Ingress
        ingressAnnotations: {}
        # tls: true
        # tlsSecretName: {}
        host: my-service.example.com
        # path: {}
        # pathType: {}
        # servicePort: {}
        # ingressClassName: {}

    # Description of the ConfigMap
    configmap:
      # The contents of the config can be set via
      # `--set-file "applications[0].configmap[0].data"="config.json"`
      # `mountPath` - the path in the container where all configs will be mapped
      # `files[0].name` - the name of the file in the container
      # `files[0].data` - the config body is set via the --set-file parameter
      mountPath: "/configs"
      files:
        - name: "config.json"
          data: {}

    # Description of the Secret
    secret: {}
```


### Example values for `cronJobs`
```yaml
# An example of a fully described value file for describing the simplest cornjob
---
# Description of the cronjob
cronjobs:
  - name: cronjob-example
    image:
      # Image Link
      repository: group/image-cronjob
      version: "1.0.0"
      # Secret name with dockerconfig (for private registry)
      pullsecrets: secret-registry-user
      # `IfNotPresent` - only if the image is missing locally
      # `Always` - the image is pumped out every time the hearth is started
      # `Never` - it is never pumped out, only local images
      imagePullPolicy: IfNotPresent
    # Redefine resource quotas
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
    # If it is necessary to predefine or replace the commands/arguments
    commands:
      - sh
    args:
      - -c
      - env
    # Container environment variables
    envs:
      LOG_LEVEL: info
    # Environment variables to extract from the secret
    envsSecret: []
    #  - name: SECRET_USERNAME
    #    keySecret: username
    # Sheduling plan (as in the crown)
    schedule: "* * * * *"
    # Storing the history of jobs completed with an error
    failedJobsHistoryLimit: 1
    # Storing the history of jobs completed successfully
    successfulJobsHistoryLimit: 0
    # The policy of restarting jobs if the pod failed with an error
    # Default `Never``
    restartPolicy: "OnFailure"
    # The time (sec) after which completed (success/faild) jobs will be cleared
    # Default: 360
    ttlSecondsAfterFinished: 360
    # The time (in seconds) after which the job will be forcibly terminated
    # Default: 600
    activeDeadlineSeconds: 650
    # The number of attempts to restart the job, if it failed with an error
    # Default: 3
    backoffLimit: 1
    # Policy of simultaneous launch of instances of jobs
    # Allow, Forbid, Replace
    # Default: "Forbid"
    concurrencyPolicy: "Forbid"
    # Allowed number of jobs running at the same time
    parallelism: 1
    # The number of pods that must end with success in order
    # for the job to be considered Complete
    # Default: 1
    completions: 1
    # Redefine the affinity of the pod
    affinity: {}
    # nodeAffinity:
    #   requiredDuringSchedulingIgnoredDuringExecution:
    #     nodeSelectorTerms:
    #       - matchExpressions:
    #           - key: kubernetes.io/e2e-az-name
    #             operator: In
    #             values:
    #               - e2e-az1
    #               - e2e-az2
    # Redefine the nodeSelector of the pod
    nodeSelector: {}
    # Redefine the tolerations of the pod
    tolerations: []

    # Description of the ConfigMap
    configmap:
      # The contents of the config can be set via
      # `--set-file "cronjobs[0].configmap[0].data"="config.json"`
      # `mountPath` - the path in the container where all configs will be mapped
      # `files[0].name` - the name of the file in the container
      # `files[0].data` - the config body is set via the --set-file parameter
      mountPath: "/configs"
      files:
        - name: "config.json"
          data: {}

    # Description of the Secret
    secret: {}
```

### Example values for `jobs`
```yaml
# An example of a fully described value file for describing the simplest job
---
# Description of the job
jobs:
  - name: job-example
    image:
      # Image Link
      repository: group/image-job
      version: "1.0.0"
      # Secret name with dockerconfig (for private registry)
      pullsecrets: secret-registry-user
      # `IfNotPresent` - only if the image is missing locally
      # `Always` - the image is pumped out every time the hearth is started
      # `Never` - it is never pumped out, only local images
      imagePullPolicy: IfNotPresent
    # Redefine resource quotas
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
    # If it is necessary to predefine or replace the commands/arguments
    commands:
      - sh
    args:
      - -c
      - env
    # Container environment variables
    envs:
      LOG_LEVEL: info
    # Environment variables to extract from the secret
    envsSecret: []
    #  - name: SECRET_USERNAME
    #    keySecret: username
    # The policy of restarting jobs if the pod failed with an error
    # Default `Never``
    restartPolicy: "OnFailure"
    # The time (sec) after which completed (success/faild) jobs will be cleared
    # Default: 360
    ttlSecondsAfterFinished: 360
    # The time (in seconds) after which the job will be forcibly terminated
    # Default: 600
    activeDeadlineSeconds: 650
    # The number of attempts to restart the job, if it failed with an error
    # Default: 3
    backoffLimit: 1
    # Policy of simultaneous launch of instances of jobs
    # Allow, Forbid, Replace
    # Default: "Forbid"
    concurrencyPolicy: "Forbid"
    # Allowed number of jobs running at the same time
    parallelism: 1
    # The number of pods that must end with success in order
    # for the job to be considered Complete
    # Default: 1
    completions: 1
    # Redefine the affinity of the pod
    affinity: {}
    # nodeAffinity:
    #   requiredDuringSchedulingIgnoredDuringExecution:
    #     nodeSelectorTerms:
    #       - matchExpressions:
    #           - key: kubernetes.io/e2e-az-name
    #             operator: In
    #             values:
    #               - e2e-az1
    #               - e2e-az2
    # Redefine the nodeSelector of the pod
    nodeSelector: {}
    # Redefine the tolerations of the pod
    tolerations: []

    # Description of the ConfigMap
    configmap:
      # The contents of the config can be set via
      # `--set-file "cronjobs[0].configmap[0].data"="config.json"`
      # `mountPath` - the path in the container where all configs will be mapped
      # `files[0].name` - the name of the file in the container
      # `files[0].data` - the config body is set via the --set-file parameter
      mountPath: "/configs"
      files:
        - name: "config.json"
          data: {}

    # Description of the Secret
    secret: {}
```


### Example values for `rbac`
```yaml
# An example of a fully described value file for describing the simplest rbac
---
# Description of the rbac
# ServiceAccount, Role, RoleBinding
rbac:
  - name: serviceaccount-example
    rules:
      # The name of the api to which access is required for the service account
      - apiGroups:
          - ""
        # List of resources that ServiceAccount will have access to
        resources:
          - pods
        # List of rights to resources that ServiceAccount will have
        verbs:
          - get
          - watch
          - list
```

### Usage example for Gitlab-CI
**To work, you will also need to add vault-client and kubectl to the image**
```yaml
image: alpine/helm
stages:
  - deploy

deploy-helm:
  stage: deploy
  variables:
    HELM_RELEASE_NAMESPACE: default
  before_script:
    # We collect the release name for the helm chart and bring everything to lowercase
    - export HELM_RELEASE_NAME=`echo $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG | tr '[:upper:]' '[:lower:]'`
    # Log in to vault and get secret environment variables in key: value format from vault
    - export VAULT_ADDR=https://vault.example.com/
    - export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=vault-role jwt=$CI_JOB_JWT)"
    - vault kv get -format=yaml -field=data bucket1/secret1 > .helm/vault.secret.yaml
  script:
    - helm repo add obervinov https://obervinov.github.io/helm-charts
    # Example of adding the contents of an external config from your repository
    # --set-file "applications[0].configmap[0].data"="config/config.json"
    # Example of adding secret contents unloaded from vault
    # --set-file "applications[0].secret.data"=".helm/vault.secret.yaml"
    # -f .helm/values.yaml - устанавливаем путь к values.yaml файлу в вашем реппозитории
    - |
      helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template \
        --set-file "applications[0].configmap[0].data"="config/config.json" \
        --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" \
        --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
  after_script:
    # Running helm tests
    - helm test ${HELM_RELEASE_NAME} -n ${HELM_RELEASE_NAMESPACE} --logs
```

### Step-by-step description
1. Generating the release name that will be required for the team `helm install`
```bash
export HELM_RELEASE_NAME=`echo $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG | tr '[:upper:]' '[:lower:]'`
```
2. Uploading secrets from the vault to a yaml file
```bash
export VAULT_ADDR=https://vault.example.com/
export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=vault-role jwt=$CI_JOB_JWT)"
vault kv get -format=yaml -field=data bucket1/secret1 > .helm/vault.secret.yaml
```
3. Connecting the helm package registry with the chart
```bash
helm repo add obervinov https://obervinov.github.io/helm-charts
helm repo update
```
4. Creating your own file `values.yaml`
  - a basic example can be taken [here](#simple-values-for-deployment-with-configMap)
  - example for [cronjobs](#example-values-for-cronjobs)
  - example for [jobs](#example-values-for-jobs)
  - example for [rbac](#example-values-for-rbac)
  - full description of all available values [here](values.yaml) or execute the command `helm show values obervinov/universal-template`

5. We are installing a release from this chart
```bash
# ${HELM_RELEASE_NAME} - release name, consisting of the project name and the name of the current branch in gtilab
# obervinov/universal-template - link to the package in the connected repository
# --set-file "applications[0].configmap[0].data"="config/config.json" - we throw the contents of the external config into the chart
# --set-file "applications[0].secret.data"=".helm/vault.secret..yaml" - we forward the data received from the volt to the chart
# --namespace=${HELM_RELEASE_NAMESPACE} - namespace in the kube to install the chart
# -f .helm/values.yaml - a link to the values file created in the previous step
helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template --set-file "applications[0].configmap[0].data"="config/config.json" --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
```
6. Running basic Helm tests<br />
```bash
# ${HELM_RELEASE_NAMESPACE} - namespace of the installed chart
# ${HELM_RELEASE_NAME} - release name, consisting of the project name and the name of the current branch in gitlab
# --logs output of logs from test pods
helm test ${HELM_RELEASE_NAME} -n ${HELM_RELEASE_NAMESPACE} --logs
```
#### Allocation of resources to containers (resources):
By default, there are limits in the protection template:
```yaml
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
```
#### How to guarantee the deployment of new fruits after changing the config:
In key `podAnnotations `adding a key `checksum/values.yaml` in the value, specify the path to file `values.yaml`
```yaml
        podAnnotations:
          checksum/values.yaml: ".helm/values.yaml"
```
