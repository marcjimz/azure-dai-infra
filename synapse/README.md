---
title: 'Quickstart: Create an Azure Synapse workspace Azure Resource Manager template (ARM template)'
description: Learn how to create a Synapse workspace by using Azure Resource Manager template (ARM template).
services: azure-resource-manager
ms.service: synapse-analytics
ms.subservice: workspace
ms.topic: quickstart
ms.custom: subject-armqs, mode-arm, devx-track-arm-template
author: marcjimenezMSFT
ms.author: marcjimz
ms.date: 02/04/2022
---

# Quickstart: Create an Azure Synapse workspace using an ARM template

This Azure Resource Manager (ARM) template will create an Azure Synapse workspace with underlying Data Lake Storage. The Azure Synapse workspace is a securable collaboration boundary for analytics processes in Azure Synapse Analytics.

If your environment meets the prerequisites and you're familiar with using ARM templates, select the **Deploy to Azure** button. The template will open in the Azure portal.

## Prerequisites

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

To create an Azure Synapse workspace, a user must have **Azure Contributor** role and **User Access Administrator** permissions, or the **Owner** role in the subscription. 

Azure CLI must also be installed and configured to the same active subscription.

The subscription must also be registed with Azure SQL. To do so you can run:

```sh
az provider register --namespace Microsoft.Sql
```

## Review the template

The template is sourced from the **AzureSynapseEndToEndDemo** [repository](https://github.com/microsoft/AzureSynapseEndToEndDemo/tree/main/ARMTemplate). The template defines resources:

- Storage account
- Workspace
- Spark Pools

## Parameters

| Name                            | Required | Description                                                                                                   |
|---------------------------------|----------|---------------------------------------------------------------------------------------------------------------|
| StorageAcccountName             | yes      | Name of the Storage Account.                                                                                  |
| StorageContainerName            | yes      | Name of the Container in Storage Account.                                                                     |
| WorkspaceName                   | yes      | Name of the Synapse Workspace.                                                                                |
| ManagedResourceGroupName        | yes      | Name of the Managed Resource Group for Synapse.                                                               |
| SqlPoolName                     | yes      | Name of the dedicated SQL pool.                                                                               |
| SparkPoolName                   | yes      | Name of the Synapse spark pool. Maximum length of 15 characters.                                              |
| sqlAdministratorLogin           | yes      | The username of the SQL Administrator.                                                                        |
| sqlAdministratorLoginPassword   | yes      | The password for the SQL Administrator. This is a secure string.                                              |
| githubUsername                  | yes      | Username of your github account hosting synapse workspace resources.                                          |
| sparkNodeSize                   | no       | Size of the node if SparkDeployment is true. Defaults to 'Small'. Allowed values: 'Small', 'Medium', 'Large'. |
| metadataSync                    | no       | Choose whether you want to synchronize metadata. Defaults to true.                                            |
| sku                             | no       | Select the SKU of the SQL pool. Defaults to 'DW100c'. Allowed values range from 'DW100c' to 'DW3000c'.        |

## Deploy the template

1. Configure the parameters as properly, updating the values as required.

2. Set the subscription ID as follows:

```sh
az account set --subscription <SUBSCRIPTION_ID>
```

3. Set and run the following command to initialize the parameters:

```sh
# Change these values before execution.
export RESOURCE_GROUP="dev-synapse"
export RESOURCE_GROUP_MNGD="dev-synapse-mgd"
export REGION="West US"
export WORKSPACE_NAME="synapse-poc-demo"
export SQL_USERNAME="admin"
export SQL_PASSWORD="password"
export STORAGE_ACCOUNT_NAME="synapsedemopoc"
export STORAGE_CONTAINER_NAME="synapse"
export SQL_POOL_NAME="sqlpoolpoc"
export SPARK_POOL_NAME="sparkpoolpoc"
export GITHUB_USERNAME="marcjimz"
```

4. If necessary, create the resource group to land the resource in as required:

```sh
region_formatted="${REGION,,}"  # Convert to lowercase
region_formatted="${region_formatted// /}"  # Remove spaces
az group create --name $RESOURCE_GROUP --location $region_formatted --tags Environment=Dev Project=SynapseDemo
```

5. Run the following command to initialize the deployment:

```sh
chmod +x ../deploy.sh
../deploy.sh synapse \
    ResourceGroupName="$RESOURCE_GROUP" \
    WorkspaceName="$WORKSPACE_NAME" \
    sqlAdministratorLogin="$SQL_USERNAME" \
    sqlAdministratorLoginPassword="$SQL_PASSWORD" \
    StorageAcccountName="$STORAGE_ACCOUNT_NAME" \
    StorageContainerName="$STORAGE_CONTAINER_NAME" \
    SqlPoolName="$SQL_POOL_NAME" \
    SparkPoolName="$SPARK_POOL_NAME" \
    githubUsername="$GITHUB_USERNAME" \
    ManagedResourceGroupName="$RESOURCE_GROUP_MNGD"
```

Work through any validation errors that come up from the deployment.

6. Additional permissions are required. Assign other users the appropriate **[Synapse RBAC roles](security/synapse-workspace-synapse-rbac-roles.md)** using Synapse Studio (via the UI). A member of the **Owner** role of the Azure Storage account must assign the **Storage Blob Data Contributor** role to the Azure Synapse workspace MSI and other users.

## Next steps

To learn more about Azure Synapse Analytics and Azure Resource Manager,

- Read an [Overview of Azure Synapse Analytics](../synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is.md)
- Learn more about [Azure Resource Manager](../azure-resource-manager/management/overview.md)
- [Create and deploy your first ARM template](../azure-resource-manager/templates/template-tutorial-create-first-template.md)

Next, you can [create SQL pools](quickstart-create-sql-pool-studio.md) or [create Apache Spark pools](quickstart-create-apache-spark-pool-studio.md) to start analyzing and exploring your data. 

Finally, you can follow the complete [end to end demo](https://github.com/microsoft/AzureSynapseEndToEndDemo/tree/main).