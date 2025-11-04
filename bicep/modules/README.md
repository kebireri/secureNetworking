# Secure Networking 

## Phase 1
## Overview
This folder contains the Bicep template and supporting files that define the secure network foundation for the Azure Secure Networking Project.  
It deploys a virtual network, two subnets, and network security groups (NSGs) that control inbound and outbound traffic between the web and data tiers.

---

## Components
- **Virtual Network** – Creates the base address space (10.0.0.0/16).  
- **Web Subnet** – Public-facing subnet protected by its own NSG.  
- **Data Subnet** – Private subnet isolated from the internet.  
- **NSG Rules** –  
  - Allow HTTPS (443) from any source to the web subnet  
  - Allow SSH (22) from the admin IP range  
  - Allow SQL (1433) traffic only from the web subnet to the data subnet  
  - Deny all other inbound traffic  

## Purpose
The template demonstrates how to express Azure networking concepts declaratively using Bicep.  
It also serves as the foundation for later phases, where Bastion access, peering, and monitoring will build on this base network.

---

## Phase 2 (Update):

The second phase introduces secure administrative access to the network environment using **Azure Bastion**.  
Azure Bastion allows RDP and SSH connections to virtual machines **without exposing public IPs** or open ports to the internet.  

---

## Overview

This phase adds:
- A **dedicated AzureBastionSubnet** to the virtual network  
- A **public IP (Standard, Static)** for Bastion  
- A **Bastion Host** resource linked to that subnet and IP  
- An additional **NSG rule** allowing management traffic (22/3389) only from the Bastion subnet

All deployments were executed through **modular Bicep templates**, ensuring reusable and well-structured infrastructure as code.  

The resources were automatically **validated against governance policies** from the [Azure Policy as Code project](https://github.com/kebireri/azure-bicep/tree/main/policyAsCode/groupPolicy), ensuring compliance with standards for resource tagging, network configuration, security enforcement, and naming conventions  

---

## Security Update

The initial **Allow-SSH-from-MyIP** NSG rule, used during the first deployment phase, has been **deprecated**.  
It was originally included to allow temporary administrative access to virtual machines directly from a trusted client IP for testing.  

Following the introduction of Azure Bastion:
- Direct SSH/RDP access from external public IPs is no longer required.  
- Administrative access is now performed **entirely through Bastion**, which provides secure browser-based connections from within the Azure network.  
- The deprecated rule has been **commented out in code** (for documentation) and replaced by a rule that allows management traffic only from the **Bastion subnet**.  

This update improves the network’s security posture by eliminating exposed SSH ports while maintaining documented traceability for historical context.

## Phase 3 (Update):

This phase expands the secure network architecture into a hub and spoke topology by creating a new Spoke VNet (vnet-spoke) and connecting it privately to the existing Hub VNet (secureLabVnet) through Azure VNet Peering.

The spoke network hosts an App VM within a dedicated subnet (AppSubnet), accessible only through internal routes from the hub.

Peering allows seamless, low latency communication between both VNets over Azure’s private backbone without using public IPs or internet routing, while maintaining full isolation and independent control of each network.

This configuration supports centralized management and shared services in the hub, such as Bastion, with application workloads securely deployed in the spoke

### Phase 4 (Update)

This phase enables observability across the deployed environment. A Log Analytics Workspace was created and connected to the virtual machines through the Azure Monitor Agent (AMA). Diagnostic settings were configured on key resources—VMs, NSGs, Bastion, and Storage—to collect metrics and activity logs in a central workspace.

Using **Azure Bastion**, the virtual machine in the paired (spoke) network was accessed securely through the hub without exposing SSH or RDP ports. This verified that network peering and Bastion connectivity were correctly configured.

Monitoring provides visibility into performance, availability, and security events, allowing proactive detection and response. The environment is now observable, auditable, and aligned with operational best practices.
