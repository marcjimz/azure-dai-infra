#!/bin/bash

# Initialize variables
resourceFolder=""
subscriptionId=""
resourceGroupName=""
location=""
workspaceName=""
sqlAdminLogin=""
sqlAdminPassword=""

# Usage function
usage() {
    echo "Usage: $0 -d <ResourceFolder> -s <SubscriptionId> -g <ResourceGroupName> -l <Location> -n <WorkspaceName> -u <SQLAdminLogin> -p <SQLAdminPassword>"
    exit 1
}

# Parse command line arguments
while getopts "d:s:g:l:n:u:p:" opt; do
    case $opt in
        d) resourceFolder=$OPTARG;;
        s) subscriptionId=$OPTARG;;
        g) resourceGroupName=$OPTARG;;
        l) location=$OPTARG;;
        n) workspaceName=$OPTARG;;
        u) sqlAdminLogin=$OPTARG;;
        p) sqlAdminPassword=$OPTARG;;
        *) usage;;
    esac
done

# Check if all required parameters are given
if [ -z "$resourceFolder" ] || [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$location" ] || [ -z "$workspaceName" ] || [ -z "$sqlAdminLogin" ] || [ -z "$sqlAdminPassword" ]; then
    echo "All parameters are required."
    usage
fi

# Define paths to the ARM template and parameters file
templateFile="$resourceFolder/azuredeploy.json"
parametersFile="$resourceFolder/parameters.json"

# Read parameters.json and substitute the values
tempParametersFile="$resourceFolder/temp_parameters.json"
cp $parametersFile $tempParametersFile

# Use sed to replace placeholders in the temp_parameters.json file
sed -i "s/YourSubscriptionId/$subscriptionId/g" $tempParametersFile
sed -i "s/YourNewResourceGroupName/$resourceGroupName/g" $tempParametersFile
sed -i "s/Central US/$location/g" $tempParametersFile
sed -i "s/YourWorkspaceName/$workspaceName/g" $tempParametersFile
sed -i "s/YourSQLAdminUsername/$sqlAdminLogin/g" $tempParametersFile
sed -i "s/YourSQLAdminPassword/$sqlAdminPassword/g" $tempParametersFile

# Deploy the ARM template with the modified parameters
az deployment group create \
    --name exampleDeployment \
    --resource-group $resourceGroupName \
    --template-file $templateFile \
    --parameters @$tempParametersFile

# Clean up the temporary parameters file
rm $tempParametersFile

echo "Deployment completed and cleanup done."
