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

## Review the template

The template is sourced from the `Azure-Samples` [repository](https://github.com/Azure-Samples/Synapse/blob/main/Manage/DeployWorkspace/workspace/azuredeploy.json). The template defines two resources:

- Storage account
- Workspace

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

2. Run the following command to initialize the deployment:

```sh
./deploy.sh -d /path/to/resource -s YourSubscriptionId -g YourResourceGroupName -l "Central US" -n YourWorkspaceName -u YourSQLAdminUsername -p YourSQLAdminPassword
```

3. Additional permissions are required. The attached script can be used to add a user to the contributor role of the workspace. Assign other users the appropriate **[Synapse RBAC roles](security/synapse-workspace-synapse-rbac-roles.md)** using Synapse Studio (via the UI).

4. A member of the **Owner** role of the Azure Storage account must assign the **Storage Blob Data Contributor** role to the Azure Synapse workspace MSI and other users.

## Next steps

To learn more about Azure Synapse Analytics and Azure Resource Manager,

- Read an [Overview of Azure Synapse Analytics](../synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is.md)
- Learn more about [Azure Resource Manager](../azure-resource-manager/management/overview.md)
- [Create and deploy your first ARM template](../azure-resource-manager/templates/template-tutorial-create-first-template.md)

Next, you can [create SQL pools](quickstart-create-sql-pool-studio.md) or [create Apache Spark pools](quickstart-create-apache-spark-pool-studio.md) to start analyzing and exploring your data.