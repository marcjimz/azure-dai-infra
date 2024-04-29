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

| name | required | description |
--- | --- | ---
| Name | yes | A name to use for your new Azure Synapse workspace and Data Lake Storage account |
| Storage | no | A name of the underlying Azure Data Lake storage. Use one storage account for multiple workspaces in the region. See [naming restrictions](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules#microsoftdatalakestore). If not provided, the workspace name will be used. |
| Sql Administrator Login | yes | SQL administrator login name that will access SQL endpoint. |
| Sql Administrator Password | yes | SQL administrator login password for accessing SQL endpoint. |
| Tag Values | no | Resource tags |
| CMK Uri | no | Customer-managed key uri from Key Vault for double encryption |

NOTE: If you want to provide a customer-managed key (CMK) from Key Vault for double encryption, you can get the uri from the portal. See [here](https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal#retrieve-a-secret-from-key-vault) for details on how to get the uri from Key Vault and [here](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/workspaces-encryption) for more information on encryption in Azure Synapse in general.

## Deploy the template

1. Configure the parameters as properly, updating the following values:

   - **Subscription**: Select an Azure subscription.
   - **Resource group**: Select **Create new** and enter a unique name for the resource group and select **OK**. A new resource group will facilitate resource clean up.
   - **Region**: Select a region.  For example, **Central US**.
   - **Name**: Enter a name for your workspace.
   - **SQL Administrator login**: Enter the administrator username for the SQL Server.
   - **SQL Administrator password**: Enter the administrator password for the SQL Server.
   - **Tag Values**: Accept the default.
   - **Review and Create**: Select.
   - **Create**: Select.

2. Set the subscription ID as follows:

```sh
az account set --subscription <SUBSCRIPTION_ID>
```

3. Set and run the following command to initialize the parameters:

```sh
# Change these values before execution.
export RESOURCE_GROUP="dev-synapse"
export REGION="West US"
export WORKSPACE_NAME="synapse-poc-demo"
export SQL_USERNAME="admin"
export SQL_PASSWORD="password"
export STORAGE_ACCOUNT_NAME="synapsedemopoc"
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
../deploy.sh ResourceGroupName="$RESOURCE_GROUP" workspaceName="$WORKSPACE_NAME" sqlAdministratorLogin="$SQL_USERNAME" sqlAdministratorPassword="$SQL_PASSWORD" storageAccountName="$STORAGE_ACCOUNT_NAME"
```

Work through any validation errors that come up from the deployment utility.

6. Additional permissions are required. Assign other users the appropriate **[Synapse RBAC roles](security/synapse-workspace-synapse-rbac-roles.md)** using Synapse Studio (via the UI). A member of the **Owner** role of the Azure Storage account must assign the **Storage Blob Data Contributor** role to the Azure Synapse workspace MSI and other users.

## Next steps

To learn more about Azure Synapse Analytics and Azure Resource Manager,

- Read an [Overview of Azure Synapse Analytics](../synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is.md)
- Learn more about [Azure Resource Manager](../azure-resource-manager/management/overview.md)
- [Create and deploy your first ARM template](../azure-resource-manager/templates/template-tutorial-create-first-template.md)

Next, you can [create SQL pools](quickstart-create-sql-pool-studio.md) or [create Apache Spark pools](quickstart-create-apache-spark-pool-studio.md) to start analyzing and exploring your data.