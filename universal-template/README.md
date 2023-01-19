# Helm-chart template для сервисов Юлы
## Main
This universal helm chart template is designed to simplify rolling out simple releases and speed up the helm implementation process. There is no need to write new charts for each microservice, you can use one by changing only values.yaml<br></br>
As an example, gitlab-ci will be used to use and integrate the helm chart.

## How to use it
### Example for gitlab-ci
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
4. Creating your own file `values.yaml`<br />A basic example can be taken here [here](values-base.example.yaml).<br />Example for [cronjobs](values-cronjobs.example.yaml).<br />Example for [jobs](values-jobs.example.yaml).<br />Example for [rbac](values-rbac.example.yaml).<br />Full description of all available values [here](values.yaml) or execute the command `helm show values obervinov/universal-template`

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
