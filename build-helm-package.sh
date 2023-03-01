# Check helm plugin for json-schemas generation
printf "Helm checking plugin schema-gen...\n"
plugin=$(helm plugin list | grep schema-gen)
if [[ -z "$plugin" ]]; then
    printf "Helm plugin install helm-schema-gen\n"
    helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git
else
    printf "Helm plugin schema-gen already installed\n"
    printf "============================\n\n"
fi

# Get all charts directories 
charts=$(ls -d src/*)
printf "Discovered charts:\n"
for chart in ${charts[@]}; do
    printf " + %s\n" "${chart}"
done
printf "============================\n"

# Generate josn-scemas for all charts
printf "Creating json-schemas for charts:\n"
for chart in ${charts[@]}; do
    printf " + %s\n" "${chart}"
    if [[ -f "${chart}/values.yaml" ]]; then
        helm schema-gen ${chart}/values.yaml > ${chart}/values.schema.json
    else
        printf "   values in %s/values.yaml doesn't exist\n   mearging *.example.yaml to values.yaml...\n" "${chart}"
        yq ea '. as $item ireduce ({}; . * $item )' ${chart}/*.example.yaml > ${chart}/values.yaml
        printf "   mearged all examples file in ${chart}/values.yaml successful\n"
        helm schema-gen ${chart}/values.yaml > ${chart}/values.schema.json
    fi
done
printf "============================\n"

# Validate with helm lint
printf "Running helm lint:\n"
for chart in ${charts[@]}; do
    printf " + linting %s\n" "${chart}"
    helm lint ${chart}/.
done
printf "============================\n"

# Build helm package
printf "Creating helm package:\n" 
for chart in ${charts[@]}; do
    printf " + %s\n" $chart
    helm package ./${chart} --dependency-update
done
printf "============================\n"

# Update helm index
printf "Building helm index.yaml\n"
helm repo index --url https://obervinov.github.io/helm-charts --merge index.yaml .
printf "============================\n"
printf "*** DONE ***\n"
