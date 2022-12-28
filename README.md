# helm-charts
This repository contains helm traits for all occasions

### Building json-schemas
```
helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git
helm schema-gen values.yaml > values.schema.json
```

### Creating helm package registry
```
echo -e “User-Agent: *\nDisallow: /” > robots.txt
helm package ./${CHART_PATH}
helm repo index --url https://github.com/obervinov/helm-charts/ .
cat index.yaml
```