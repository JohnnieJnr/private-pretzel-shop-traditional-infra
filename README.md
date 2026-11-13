# Private Pretzel Shop – Traditional Infrastructure

Terraform infrastructure for the Private Pretzel Shop on **DigitalOcean**. Environment configurations compose reusable modules instead of duplicating application and database resource definitions.

## Structure

```
.
├── environments/
│   ├── test/                 # Staging application environment
│   ├── production/           # Production application environment
│   └── shared-services/      # Shared DigitalOcean project
├── modules/
│   ├── app/                  # Reusable DigitalOcean App Platform application
│   ├── database/             # Reusable PostgreSQL and Valkey cluster module
│   └── prometheus/           # Reserved module for Prometheus infrastructure
└── .terraform-version
```

Each directory under `environments/` is an independent Terraform root module with its own remote-state key. It creates the environment-specific DigitalOcean project and passes its environment values into modules under `modules/`.

## Reusable modules

| Module | Purpose | Used by |
| --- | --- | --- |
| `modules/app` | Creates the DigitalOcean App Platform application, including frontend, backend, and observability services. It receives environment configuration, database cluster names, project ID, and GHCR credentials. | `test`, `production` |
| `modules/database` | Creates either a PostgreSQL cluster or a Valkey cluster and exposes connection details, CA certificates, and cluster names. | `test`, `production` |
| `modules/prometheus` | Placeholder for Prometheus-specific infrastructure. | Not currently composed by an environment |

The test and production roots invoke `database` twice—once for PostgreSQL and once for Valkey—then supply the resulting cluster names and connection details to the `app` module. Production additionally manages its custom DigitalOcean domain.

To reuse a module in another environment, add a module block with a relative source, for example:

```hcl
module "postgres" {
  source = "../../modules/database"

  cluster_name    = "pretzel-shop-qa-postgres"
  create_postgres = true
  project_id      = digitalocean_project.this.id
  environment     = "staging"
  tags            = local.tags
}
```

## Prerequisites

- Terraform 1.13 or later (see `.terraform-version`).
- A DigitalOcean API token, provided as `DIGITALOCEAN_TOKEN`.
- DigitalOcean Spaces access keys for the S3-compatible remote-state backend, provided as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- GitHub Container Registry credentials in `username:token` form for application environments (`ghcr_credentials`).

## Usage

1. Export the required credentials:

   ```bash
   export DIGITALOCEAN_TOKEN="your-do-api-token"
   export AWS_ACCESS_KEY_ID="your-spaces-key"
   export AWS_SECRET_ACCESS_KEY="your-spaces-secret"
   ```

2. Set the environment inputs. Application environments require `ghcr_credentials`; production also requires `domain`. Supply them through a `terraform.tfvars` file or `TF_VAR_*` environment variables. Do not commit credentials.

3. Initialize and apply the chosen environment:

   ```bash
   cd environments/test
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

   Replace `test` with `production` or `shared-services` as appropriate. The configured backend stores state in the `pretzel-shop-tfstate-bucket1` DigitalOcean Space under a separate key per environment.

## Adding infrastructure

- Add reusable resource groups under `modules/<name>/`, defining their inputs in `variables.tf` and stable outputs in `outputs.tf`.
- Compose a module from an environment root using `source = "../../modules/<name>"` and pass only environment-specific values.
- Keep environment-only resources, backend configuration, provider configuration, and environment locals in `environments/<environment>/`.

This separation lets application and database changes be made once in a module and consistently applied across environments.
