# tf-modules

Personal reusable Terraform module library, organised by provider.

```
gcp/          # Google Cloud modules
  vpc/        # VPC + subnet + secondary ranges + private services access
  gke/        # GKE Standard cluster + node pool (Workload Identity)
  ...         # cloud-sql, gcs-bucket, artifact-registry, identity-platform, ... (added as needed)
kubernetes/   # cloud-agnostic k8s modules (web-deployment, traefik, keel) — added later
```

## Usage

Consume by git ref (pin a tag):

```hcl
module "gke" {
  source = "git::https://github.com/<owner>/tf-modules//gcp/gke?ref=v0.1.0"
  # ...
}
```

The `//` separates the repo from the module subdirectory. Tags version the whole repo.

## Releases

- `v0.1.0` — `gcp/vpc`, `gcp/gke`
- `v0.2.0` — adds `gcp/cloud-sql`
- `v0.2.1` — `cloud-sql`: pin `edition` (default ENTERPRISE) so `db-custom-*` tiers work
