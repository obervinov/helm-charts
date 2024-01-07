### Helm chart for generating CRDs for Terraform Cloud Operator.
All available parameters and their values are described in [values.yaml](values.yaml)

Helm dependencies that are needed to scan the chart are in the dependencies section [Chart.yaml](Chart.yaml)

This chart generating CRDs for [this operator](https://github.com/hashicorp/terraform-cloud-operator).
Supported:
- Workspace
- AgentPool


### Examples
```yaml
---
global:
  apiVersion: app.terraform.io/v1alpha2
  namespace: default
  organization: organization1
  terraformApiTokenSecret:
    name: terraform-operator
    key: token
  agent:
    terraformVersion: 1.6.6
    applyMethod: manual
    executeMode: agent
    agentPool: default
    serviceAccountName: terraform-agent
  notification:
    type: email
    triggers:
      - "run:errored"
    users:
      - "user1@example.com"
  vcs:
    oAuthTokenID: 123
    repository: "organization1/terraform-repo"
  tags:
    - "tag1"

workspaces:
  - name: workspace1
    description: "Workspace 1"
    workingDirectory: "infrastructure/service1"
    notificationName: Notify from workspace1
    applyMethod: auto-approve
    additionalTags:
      - "additionalTag1"
    environmentVariables:
      - name: TF_VAR_region
        description: "AWS region"
        sensitive: false
        value: "us-east-1"
    terraformVariables:
      - name: TF_VAR_region
        description: "AWS region"
        sensitive: false
        value: "us-east-1"

agentPools:
  - name: agentpool1
    replicas: 1
    resources:
      limits:
        cpu: null
        memory: 512Mi
      requests:
        cpu: null
        memory: 128Mi

rbac:
  rules:
    - apiGroups:
        - ""
      resources:
        - pods
        - deployments
      verbs:
        - get
        - list
        - watch
```
