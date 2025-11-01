# Azure Secure Networking Project

## Overview
This project demonstrates how to design and deploy a secure network in Microsoft Azure using Bicep and the Azure CLI.  
It focuses on creating an environment where network traffic is isolated, controlled, and protected according to best practices.

The project builds on the previous [**Azure Governance (Policy as Code)** project](https://github.com/kebireri/azure-bicep/tree/main/policyAsCode/groupPolicy), which established resource organization, compliance, and tagging standards.  
Together, these projects form part of a broader learning path in cloud architecture and DevOps engineering.

While this project follows naturally from that work, it can also be implemented as a **stand-alone project** to demonstrate secure networking concepts independently.

---

## Purpose

This project demonstrates how network security and access control can be applied and automated through infrastructure as code in Azure.  
It provides a clear path for building secure, isolated environments that align with governance and compliance practices from the previous project.  

Each phase focuses on a key area of network design: foundation, access, connectivity, and visibility.  
Together, they form a practical example of how Azure resources can be deployed and managed securely at scale.

---

## Project Phases

This project is designed to teach and demonstrate secure network design principles in Azure.  
It is divided into four phases, with each phase focusing on a core aspect of cloud networking: isolation, access control, connectivity, and visibility.  
By progressing through the phases, you gain practical experience in building a complete and secure Azure network architecture.

- **Phase 1 – Secure Network Foundation**  
Creates the base network: one virtual network with two subnets (web and data) and a network security group (NSG) applied to each subnet.  
The NSGs define which types of traffic are allowed or denied, forming the first layer of network protection.

---
             Internet (Public Network)
                        |
                        v
    ______________________________________________________________
    |              secureLabVNet (10.0.0.0/16)                   |
    |____________________________________________________________|
    |                                                            |
    |  +---------------------+      +-------------------------+  |
    |  | webSubnet 10.0.1.0  | ---> | dataSubnet 10.0.2.0     |  |
    |  | webSubnet-nsg       |      | dataSubnet-nsg          |  |
    |  | - Allow HTTPS 443   |      | - Allow SQL 1433 from   |  |
    |  |   from Internet     |      |   webSubnet             |  |
    |  | - Allow SSH 22 from |      | - Deny all others       |  |
    |  |   admin IP (initial)|      |                         |  |
    |  | - Deny all others   |      |                         |  |
    |  +---------------------+      +-------------------------+  |
    |                                                            |
    |____________________________________________________________|
---

- **Phase 2 – Azure Bastion Access**  

Adds Azure Bastion for secure administrative access to virtual machines inside the network without exposing SSH or RDP ports to the internet.
This phase introduces Azure Bastion to provide secure, browser-based administrative access to virtual machines without exposing SSH or RDP ports to the Internet. It replaces direct public access with a managed, policy-compliant connection through the Bastion host inside the virtual network.

                 Internet (Admins only via Azure Portal)
                            │
                +-------------------------+
                |  Azure Bastion Public IP |
                +-----------+--------------+
                            │
                            ▼
    ______________________________________________________________
    |              secureLabVNet (10.0.0.0/16)                   |
    |____________________________________________________________|
    |                                                            |
    |  AzureBastionSubnet 10.0.3.0/26                            |
    |  +---------------------------------------------+           |
    |  | Azure Bastion Host                          |           |
    |  | - Origin for admin SSH/RDP (22/3389)        |           |
    |  | - Uses static, Standard public IP           |           |
    |  +------------------+--------------------------+           |
    |                     │                                      |
    |      Allow 22/3389  │                                      |
    |                     │                                      |
    |  +---------------------+      +-------------------------+  |
    |  | webSubnet 10.0.1.0  | -->  | dataSubnet 10.0.2.0     |  |
    |  | webSubnet-nsg        |     | dataSubnet-nsg          |  |
    |  | - Allow SQL 1433 →   |     | - Allow 1433 from web   |  |
    |  |   dataSubnet         |     |   subnet                |  |
    |  | - Allow SSH/RDP from |     | - Allow SSH/RDP from    |  |
    |  |   Bastion subnet     |     |   Bastion subnet        |  |
    |  | - Deny all others    |     | - Deny all others       |  |
    |  +----------------------+     +-------------------------+  |
    |                                                            |
    |____________________________________________________________|
---

- **Phase 3 – Network Peering**  
Connects this virtual network to another Azure virtual network using peering.  
This allows resources in different environments to communicate privately without using public endpoints.

- **Phase 4 – Network Monitoring**  
Introduces monitoring and logging.  
It enables NSG flow logs, diagnostic settings, and traffic analytics so that network activity can be observed and reviewed for compliance and performance.


