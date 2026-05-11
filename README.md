# Azure Hub-and-Spoke Network Topology

## Architecture Diagram
![Architecture Diagram](Architecture-diagram.png)

## What This Builds
This project deploys a hub-and-spoke network topology on Azure using Terraform.
It includes one hub VNet, two spoke VNets, VNet peering, a VPN gateway, and a
simulated on-premises network connected via Site-to-Site VPN with BGP enabled.

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (v1.0+)
- An active Azure subscription

## Deployment Commands
```bash
terraform init
terraform plan
terraform apply
```

## Architecture Decisions
- **Hub-and-spoke** — centralises shared services and security in the hub
- **BGP over S2S VPN** — dynamic routing between Azure and on-premises
- **VNet Peering** — low latency connectivity between hub and spokes
- **UDRs** — force spoke traffic through hub firewall (commented out — no firewall deployed to minimise cost)

## Screenshots
<!-- Add portal screenshots here after deployment -->

## What I Learned
<!-- Fill this in after deployment -->