# Configuring Azure Virtual Desktop (AVD) Monitoring Using Azure Policy

## Ensuring Compliance and Streamlined Management for AVD Environments

Azure Virtual Desktop (AVD) provides a robust solution for deploying and managing virtual desktops in the cloud. Monitoring the performance and security of these environments is critical to ensure optimal functionality and compliance with organizational policies. Azure Policy offers a governance framework to implement and enforce these configurations systematically. This document details how to configure AVD monitoring using Azure Policy.

## Understanding Azure Policy

For policies created:

### Assign Built-In User-Assigned Managed Identity to Virtual Machines.json

Configure Windows virtual machines to run Azure Monitor Agent with user-assigned managed identity-based authentication. These two policies will attach the managed identity to the hostpool VM.

### Configure Windows Machines to be associated with a Data Collection Rule or a Data Collection Endpoint

This policy will add the VM to the existing Data Collection Rule.

### Configure Windows Machines to be associated with a Data Collection Rule or a Data Collection Endpoint-Insights

This policy will add the VM to the VM insights Data collection rule. If you are not configuring VM insights, you can ignore this.

## Prerequisites

Before you begin configuring AVD monitoring through Azure Policy, ensure the following:

- **Managed Identity** – Two managed identities needed if you need more security.
- **PolicyAssignmentMI** – This is used to assign policies, following permissions required:
  - Managed Identity Contributor – Subscription
  - Log Analytics Contributor – Resource group
  - Monitoring Contributor – Resource group
  - User Access Administrator - Resource group
  - Contributor – Resource group
- **VMMonitor** – This managed identity will be added to the VM:
  - Log Analytics Contributor – Resource group
  - Monitoring Contributor – Resource group
  - Virtual machine Contributor - Resource group

If you are using a single Managed identity, add managed identity contributor and the rest will be added when the policy is created.

- **Log analytics workspace** – If it's in a different resource group, managed identity needs Log Analytics Contributor and Monitoring Contributor.
- **DCR rule for AVD logs** - DCR-microsoft-avdi-eastus2.json
- **DCR rule for VM Insights** - DCR-Insights.json

## Steps to Configure AVD Monitoring Using Azure Policy

### Step 1: Create policy

Create the 4 new policies in the policy folder, assign your own name.

### Step 2: Assign the Policy

After creating the policy definition, assign it to a subscription, resource group, or management group:

1. Go to the "Assignments" section within Azure Policy.
2. Click on "+ Assign policy."
3. Select the policy definition you created or a built-in policy related to monitoring.
4. Specify the scope by selecting the appropriate subscription or resource group.
5. Configure parameters, such as the Log Analytics workspace, Hostpool name, DCR rule name, Managed identity etc.
   - Assign Built-In User-Assigned Managed Identity to Virtual Machines.json
   - Configure Windows virtual machines to run Azure Monitor Agent with user-assigned managed identity-based authentication
   - Configure Windows Machines to be associated with a Data Collection Rule or a Data Collection Endpoint
   - Configure Windows Machines to be associated with a Data Collection Rule or a Data Collection Endpoint-Insights

### Step 3: Automate Remediation

For non-compliant resources, Azure Policy supports remediation tasks to automate corrections. For example:

1. Navigate to the assigned policy in the Azure Policy dashboard.
2. Click "Remediation tasks."
3. Select a remediation task to apply the required changes, such as enabling diagnostic settings on AVD session hosts.

## Latest Image

| Parameter name | Parameter value |
|----------------|-----------------|
| Bring Your Own User-Assigned Identity | true |
| User-Assigned Managed Identity Resource ID | "/subscriptions/45f715fc-56b2-44ed-9e69-8250d36d2d..." |
| Built-In Identity-RG Location | "eastus2" |
| User-Assigned Managed Identity Name | "NYC-ID" |
| User-Assigned Managed Identity Resource Group Name | "NYC" |
| Policy Effect | "DeployIfNotExists" |
| Restrict Bring Your Own User-Assigned Identity to Subscription | true |

image_url_here
