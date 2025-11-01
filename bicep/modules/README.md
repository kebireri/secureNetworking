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

The resources were automatically **validated against governance policies** from the [Azure Policy as Code project](https://github.com/kebireri/azure-bicep/tree/main/policyAsCode/groupPolicy), ensuring compliance with standards for:
- Resource tagging  
- Network configuration  
- Security enforcement  
- Naming conventions  

---

## Security Update

The initial **Allow-SSH-from-MyIP** NSG rule, used during the first deployment phase, has been **deprecated**.  
It was originally included to allow temporary administrative access to virtual machines directly from a trusted client IP for testing.  

Following the introduction of Azure Bastion:
- Direct SSH/RDP access from external public IPs is no longer required.  
- Administrative access is now performed **entirely through Bastion**, which provides secure browser-based connections from within the Azure network.  
- The deprecated rule has been **commented out in code** (for documentation) and replaced by a rule that allows management traffic only from the **Bastion subnet**.  

This update improves the network’s security posture by eliminating exposed SSH ports while maintaining documented traceability for historical context.