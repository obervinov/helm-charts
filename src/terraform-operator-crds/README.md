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
# Global parameters which are applied to all workspaces, agents and modules.
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

# Workspaces for managing in Terraform Cloud.
# https://github.com/hashicorp/terraform-cloud-operator/blob/main/docs/workspace.md
workspaces:
  - name: workspace1
    description: "Workspace 1"
    workingDirectory: "infrastructure/service1"
    notificationName: Notify from workspace1
    # applyMethod: auto-approve
    additionalTags:
      - "tag2"
    # environmentVariables:
    #   - name: TF_VAR_region
    #     description: "AWS region"
    #     sensitive: false
    #     value: "us-east-1"
    # terraformVariables:
    #   - name: TF_VAR_region
    #     description: "AWS region"
    #     sensitive: false
    #     value: "us-east-1"

# Agents for managing in Terraform Cloud.
# https://github.com/hashicorp/terraform-cloud-operator/blob/main/docs/agentpool.md
agentPools:
  - name: agent-pool-1
    replicas: 1
    # Resources per agent in the pool.
    # resources:
    #   limits:
    #     cpu: null
    #     memory: 512Mi
    #   requests:
    #     cpu: null
    #     memory: 128Mi

# For agent pools permissions in kubernetes cluster.
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

# Modules for managing in Terraform Cloud.
# https://github.com/hashicorp/terraform-cloud-operator/blob/main/docs/module.md
modules:
  - name: module1
    source: "https://github.com/obervinov/terraform-setup-environment"
    version: "1.0.0"
    variables:
      - var1
      - var2
    outputs:
      - output1
      - output2
    workspaces: workspace1

```
