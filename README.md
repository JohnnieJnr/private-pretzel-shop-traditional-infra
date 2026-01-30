# Private Pretzel Shop – Traditional Infra

Terraform project for **DigitalOcean** with **test** and **prod** environments. Resources are split across multiple files in each environment (no shared modules).

## Structure

```
.
├── environments/
│   ├── test/
│   │   ├── main.tf            # Backend, provider, locals
│   │   ├── variables.tf      # Input variables
│   │   ├── outputs.tf         # Output values
│   │   ├── data.tf            # Data sources
│   │   ├── network.tf         # VPC
│   │   ├── compute.tf         # Firewall (for droplets)
│   │   ├── storage.tf        # Spaces bucket (S3-compatible)
│   │   ├── terraform.tfvars   # Test variable values
│   │   └── terraform.tfvars.example
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── data.tf
│       ├── network.tf
│       ├── compute.tf
│       ├── storage.tf
│       └── terraform.tfvars   # Prod variable values
└── .terraform-version
```

## Prerequisites

- **DigitalOcean API token** – [Control Panel → API → Tokens](https://cloud.digitalocean.com/account/api/tokens)
- **Spaces keys** (for creating/managing Spaces buckets) – [Control Panel → API → Spaces Keys](https://cloud.digitalocean.com/account/api/spaces). Set `SPACES_ACCESS_KEY_ID` and `SPACES_SECRET_ACCESS_KEY` in the environment, or configure the provider with `spaces_access_id` and `spaces_secret_key`.

## Usage

1. Set the DigitalOcean token (avoid putting it in `terraform.tfvars` if the file is committed):
   ```bash
   export TF_VAR_digitalocean_token="your-do-api-token"
   ```
   For Spaces, also set (or create keys in Control Panel):
   ```bash
   export SPACES_ACCESS_KEY_ID="your-spaces-key"
   export SPACES_SECRET_ACCESS_KEY="your-spaces-secret"
   ```

2. Configure variables in `environments/<env>/terraform.tfvars` (see `terraform.tfvars.example` in test).

3. Apply an environment:
   ```bash
   cd environments/test
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
   For prod: `cd environments/prod` and run the same.

## Backend

The project uses a **local** backend by default. DigitalOcean has no native Terraform state backend. For remote state you can use:

- **Terraform Cloud**
- **S3-compatible backend** (e.g. store state in a DigitalOcean Space and use the AWS provider for the backend block)

## Resources (DigitalOcean)

| File        | Resources |
|------------|-----------|
| `network.tf` | `digitalocean_vpc` |
| `compute.tf` | `digitalocean_firewall` (attach to droplets via `droplet_ids` when you add them) |
| `storage.tf` | `digitalocean_spaces_bucket` (S3-compatible; versioning on for prod) |

Variables: `region` is a DigitalOcean region slug (e.g. `nyc3`, `sfo3`, `sgp1`). `vpc_cidr` must be RFC1918 and between /16 and /24.

## Adding variables

1. Add the variable in **`environments/<env>/variables.tf`**.
2. Set it in **`environments/<env>/terraform.tfvars`** (or `TF_VAR_*` env vars).
3. Use it in any `.tf` file in that environment.

## Adding outputs

Add the output in **`environments/<env>/outputs.tf`**, referencing resources directly (e.g. `digitalocean_vpc.main.id`).

## Splitting resources

All `.tf` files in the same environment directory are merged. Add new resources in existing files (`network.tf`, `compute.tf`, `storage.tf`, `data.tf`) or new files (e.g. `droplet.tf`, `dns.tf`).

## Terraform version

See **`.terraform-version`** (e.g. for use with `tfenv` or your version manager).
