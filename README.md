# RenewGrid — Infrastructure as Code with Terraform

**Elevate Labs | DevOps Internship — Task 3**

Infrastructure as Code implementation for deploying the RenewGrid application locally using Terraform and Docker Compose.

## Overview

This project extends the RenewGrid application and CI/CD implementations completed in Tasks 1 and 2.

Terraform manages the lifecycle of the existing RenewGrid Docker Compose application through the Docker provider.

The deployment includes:

- React frontend served by Nginx
- FastAPI backend
- PostgreSQL database
- Alembic database migrations
- Isolated Docker networks
- Persistent database and upload volumes

The application uses the versioned container images published and verified during Task 2.

## Technology Stack

Terraform 1.17.0, Docker Provider 4.6.0, Docker Compose, Docker Desktop, GitHub Actions, Nginx, React, FastAPI, PostgreSQL, and Alembic.

## Architecture

Terraform provisions one Docker Compose project named `renewgrid-iac`.

The existing Compose configuration handles service dependencies, database migrations, health checks, networking, and persistent storage.

Application request flow:

```text
Browser → Nginx/React → FastAPI → PostgreSQL
```

## Infrastructure Configuration

| Component                  | File                                       |
| -------------------------- | ------------------------------------------ |
| Terraform                  | [`terraform/main.tf`](terraform/main.tf)   |
| Docker Compose             | [`compose.yaml`](compose.yaml)             |
| Local environment template | [`.env.compose.example`](.env.compose.example) |
| CI validation              | [`.github/workflows/terraform-validate.yml`](.github/workflows/terraform-validate.yml) |
| Implementation details     | [`DEVOPS-TASK3.md`](DEVOPS-TASK3.md)       |
| Execution evidence         | [`evidence/terraform/renewgrid/`](evidence/terraform/renewgrid/) |

## Local Setup

### Prerequisites

- Terraform 1.17.0
- Docker Desktop with Linux containers
- Git

### 1. Configure the local environment

```bash
cp .env.compose.example .env.compose
```

Generate secure local credentials and update `.env.compose`.

Set `APP_PORT=8090` and configure the backend and frontend image references documented in `DEVOPS-TASK3.md`.

Do not commit `.env.compose`.

### 2. Configure Docker context

```bash
export DOCKER_CONTEXT="$(docker context show)"
```

### 3. Initialize and validate

```bash
terraform -chdir=terraform init
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
```

### 4. Review and deploy

```bash
terraform -chdir=terraform plan
terraform -chdir=terraform apply
```

### 5. Verify the application

```bash
docker compose -p renewgrid-iac --env-file .env.compose ps -a
curl -fsS http://127.0.0.1:8090/roles
curl -fsS http://127.0.0.1:8090/config
```

Open the frontend:

```text
http://localhost:8090
```

### 6. Inspect Terraform state

```bash
terraform -chdir=terraform state list
```

### 7. Destroy the deployment

```bash
terraform -chdir=terraform destroy
```

Named Docker volumes may remain after destruction to preserve application data.

## Security

- Non-root application containers
- Localhost-only frontend access (`127.0.0.1:8090`)
- Internal PostgreSQL networking
- Separate local environment configuration
- Digest-pinned application images
- Terraform provider version locking
- Terraform state excluded from Git
- Read-only GitHub Actions permissions

## Automation

GitHub Actions validates Terraform formatting and configuration, alongside the Docker Compose configuration.

The original RenewGrid application validation workflow is preserved.

## Verification Evidence

| Evidence | Description |
|---|---|
| [Terraform Plan & Verification](evidence/terraform/renewgrid/01-terraform-verified.png) | Successful Terraform init, validate, and plan execution |
| [Docker Services](evidence/terraform/renewgrid/02-renewgrid-services.png) | All 4 Docker Compose services running and healthy |
| [Web Application](evidence/terraform/renewgrid/03-renewgrid-application.png) | Running RenewGrid UI and API verified at `http://localhost:8090` |

All command logs (`01-plan.txt`, `02-apply.txt`, `03-reconciliation.txt`, `04-destroy.txt`) are recorded under [`evidence/terraform/renewgrid/`](evidence/terraform/renewgrid/).

For full technical specifications, architecture diagrams, and detailed step-by-step logs, see [DEVOPS-TASK3.md](DEVOPS-TASK3.md).

## Previous Tasks

- [Task 1 — GitHub Actions CI/CD](DEVOPS-TASK1.md) · ([GitHub Repository](https://github.com/Aoun62336/RenewGrid-DevOps))
- [Task 2 — Jenkins CI/CD on AWS EC2](DEVOPS-TASK2.md) · ([GitHub Repository](https://github.com/Aoun62336/RenewGrid-Jenkins-CICD))

## Scope

This is a local internship demonstration.

Terraform manages the Docker Compose project as one resource. The implementation does not provide cloud hosting or production high availability.