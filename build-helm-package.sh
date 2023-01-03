printf "Helm check plugin schema-gen...\n"
plugin=$(helm plugin list | grep schema-gen)
if [[ -z "$plugin" ]]; then
    printf "Helm plugin install helm-schema-gen\n"
    helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git
else
    printf "Helm plugin schema-gen already installed.\n"
fi

charts=$(ls -d */)
for chart in ${charts[@]}; do
    printf "Creating json-schema for %s\n" "${chart}"
    helm schema-gen ${chart}/values.yaml > ${chart}/values.schema.json
done

for chart in ${charts[@]}; do
    printf "Creating helm-package for %s\n" $chart
    helm package ./${chart} --dependency-update --destination _packages/
done

printf "Building helm index.yaml\n"
helm repo index --url https://obervinov.github.io/helm-charts --merge index.yaml .
