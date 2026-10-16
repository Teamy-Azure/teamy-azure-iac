# TEAMY-NETWORK-RG IP Address Management

This file is the central place to track address allocations inside TEAMY-NETWORK-RG.

## Virtual Network

- VNet name: TEAMY-NETWORK-VNET
- VNet CIDR: 10.203.0.0/16
- Region: canadacentral

## Planned Allocations

| Scope | CIDR | Status | Notes |
| --- | --- | --- | --- |
| VNet address space | 10.203.0.0/16 | allocated | Parent range for all subnet allocations in TEAMY-NETWORK-VNET. |

## Notes

- Keep all future subnet allocations within 10.203.0.0/16 unless this document is intentionally revised first.
- If this VNet ever needs peering or on-prem overlap avoidance, update this document before applying CIDR changes in Terraform.