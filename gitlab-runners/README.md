### This helm chart is designed to deploy gitlab-runners in kubernetes and store descriptions of all these runners in a dictionary (IaC)

All available parameters and their values are described in [values.yaml](values.yaml)

Helm dependencies that are needed to scan the chart are in the dependencies section [Chart.yaml](Chart.yaml)

Tokens for registering runners must be stored in the **vault**, all in one secret in the format of:

```yaml
runner1: token1
runner2: token2
runner3: token3
```

To add a secret with tokens to the chart during installation, you need to upload it to a `yaml-file` and then add it to the `registrationTokens` via `--set-file`.

For example:
```sh
vault kv get -format=yaml -field=data ${VAULT_SECRET_PATH} > secret.vault.yaml
helm upgrade --install gitlab-runners gitlab-runners/. --set-file registrationTokens=secret.vault.yaml
```
