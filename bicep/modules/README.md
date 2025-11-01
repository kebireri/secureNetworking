# Secure Networking (Phase 1)

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

---

## Purpose
The template demonstrates how to express Azure networking concepts declaratively using Bicep.  
It also serves as the foundation for later phases, where Bastion access, peering, and monitoring will build on this base network.
