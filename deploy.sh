#!/bin/bash

# Initialize associative array for parameters
declare -A params

# Define paths to the ARM template and parameters file
templateFile="azuredeploy.json"
parametersFile="azuredeploy.parameters.json"

# Usage function
usage() {
    echo "Usage: $0 key1=value1 key2=value2 ... keyN=valueN"
    echo "Example: $0 ResourceFolder=/path/to/folder SubscriptionId=example-id ResourceGroupName=my-group"
    exit 1
}

# Check for necessary utilities
for util in jq az sed; do
    if ! command -v $util &> /dev/null; then
        echo "$util could not be found. Please install $util to continue."
        exit 1
    fi
done

# Parse command line arguments
for arg in "$@"; do
    key=$(echo $arg | cut -f1 -d=)
    value=$(echo $arg | cut -f2 -d=)
    params[$key]=$value
done

# Check if at least one parameter is given
if [ ${#params[@]} -eq 0 ]; then
    echo "No parameters were provided."
    usage
fi

# Check if the parameters file exists
if [ ! -f "$parametersFile" ]; then
    echo "Parameters file does not exist: $parametersFile"
    exit 1
fi

# Validate JSON syntax (requires jq installed)
if ! jq empty $parametersFile > /dev/null 2>&1; then
    echo "JSON syntax error in $parametersFile"
    exit 1
fi

# Read parameters.json and substitute the values
#tempParametersFile="${params[ResourceFolder]}/temp_parameters.json"
tempParametersFile="temp_parameters.json"
cp $parametersFile $tempParametersFile

# Initialize jqFilter
jqFilter='.'

# Iterate over parameters and check if they exist in the original file
for key in "${!params[@]}"; do
    # Check if the parameter key exists in the original file
    if jq -e ".parameters | has(\"$key\")" "$tempParametersFile" >/dev/null; then
        echo "Substituting ${key} with '${params[$key]}' in the parameters file."
        # Construct jq filter to modify the JSON
        jqFilter+=" | .parameters.${key}.value = \"${params[$key]}\""
    else
        echo "Warning: Parameter ${key} does not exist in the original file and will not be updated."
    fi
done

# Apply the constructed jq filter
jq "$jqFilter" "$tempParametersFile" > "updated_$tempParametersFile"
mv "updated_$tempParametersFile" "$tempParametersFile" # Replace the old temp file with the new one

# Display the finalized parameters file
echo "Finalized parameters file:"
cat $tempParametersFile
echo ""  # Adding a blank line for better readability in the output

# Confirm before proceeding
read -p "Continue with deployment? (y/N) " choice
case "$choice" in
  y|Y ) echo "Deploying...";;
  * ) echo "Deployment canceled."; exit;;
esac

# Deploy the ARM template with the modified parameters
az deployment group create \
    --name exampleDeployment \
    --resource-group ${params[ResourceGroupName]} \
    --template-file $templateFile \
    --parameters @$tempParametersFile

# Clean up the temporary parameters file
rm $tempParametersFile

echo "Deployment completed and cleanup done."