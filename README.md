# CloudDock Terraform

This repository contains the Terraform infrastructure used by CloudDock to provision the AWS resources for the app.

## Option 1 — CloudDock CLI

```bash
pipx install cloud-dock-cli
clouddock init
clouddock plan
clouddock deploy
```

CloudDock generates `clouddock.yaml` and uses this Terraform repository to provision the infrastructure.

## Option 2 — Terraform directly

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Users can configure the infrastructure through `terraform.tfvars` when running Terraform directly.

## Configuration

This project supports both:

- `clouddock.yaml`
- `terraform.tfvars`

Database username and password can be configured through the active configuration method. When CloudDock generates `clouddock.yaml`, the database credentials are read from that file; when Terraform is run directly, they can be supplied in `terraform.tfvars`.