# RenewGrid — Infrastructure as Code with Terraform

**Elevate Labs | DevOps Internship — Task 3**

## Overview

RenewGrid is a full-stack, role-based e-waste recycling and rewards management platform built with React, FastAPI, PostgreSQL, and Alembic.

This repository demonstrates Infrastructure as Code (IaC) using Terraform and the Docker provider to automate the provisioning, lifecycle management, health verification, and teardown of the complete multi-container RenewGrid application.

It builds directly upon the foundational containerization established in **Task 1** and the automated Jenkins CI/CD pipeline and security hardening completed in **Task 2**.

## Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| Infrastructure as Code | Terraform (v1.17.0) | Declarative infrastructure definition and lifecycle orchestration |
| Terraform Provider | `kreuzwerker/docker` (v4.6.0) | Docker Engine and Docker Compose lifecycle provider |
| Container Orchestration | Docker Compose v2 | Multi-container application specification and networking |
| CI Validation | GitHub Actions | Automated Terraform formatting, initialization, and Compose validation |
| Frontend | React 19, Vite, TailwindCSS | Web user interface and four role-based portals |
| Web Server & Proxy | Nginx (Alpine) | Static file serving and reverse proxy to FastAPI backend |
| Backend API | Python 3.12, FastAPI, Uvicorn | RESTful API, authentication, pickup state machine, QR verification |
| Database | PostgreSQL 17 | Persistent relational database storage |
| Database Migrations | Alembic | Version-controlled schema migrations |
| Container Registry | Docker Hub | Digest-pinned application container images (`fire2686`) |

## Architecture

```text
GitHub main branch / feature branch
  → GitHub Actions Validation (terraform fmt, validate, compose config)
  → Local Terraform Execution (`terraform apply`)
  → Docker Provider provisions `docker_compose.renewgrid` ("renewgrid-iac")
  → PostgreSQL (`db`) passes health check
  → Alembic (`migrate`) applies schema updates
  → FastAPI (`api`) starts and passes health check
  → Nginx / React (`web`) exposes application at http://localhost:8090
  → Browser interacts with RenewGrid Web Application
```

## Containerized Application

The Docker Compose configuration (`compose.yaml`) defines four coordinated services:

- `db` — PostgreSQL 17 database service on internal network `data`
- `migrate` — One-time Alembic migration service executing `alembic upgrade head`
- `api` — FastAPI application backend exposed internally on port `8000`
- `web` — Nginx reverse proxy serving compiled React assets and routing `/api` traffic

Database state and user upload directories are backed by persistent Docker named volumes (`postgres_data` and `uploads_data`).

## Verified Image Repositories

The deployment uses the immutable, digest-pinned images published during Jenkins Build #7 in Task 2:

- **Backend:** `docker.io/fire2686/renewgrid-jenkins-api@sha256:6006bbabb86e874edadaebe1330a2a5853add5c863a295ee8491bd17c7354cd1`
- **Frontend:** `docker.io/fire2686/renewgrid-jenkins-web@sha256:dc8166fc3ea94caa3ed0e46b90aac039be611cbc0dda40336e943daeb6879e7d`

## Security and Best Practices

- **Non-Root Containers:** Backend and web services execute with unprivileged user permissions.
- **Network Segmentation:** PostgreSQL is placed on an isolated `internal: true` Docker network inaccessible from the host network.
- **Port Isolation:** The web service binds strictly to the loopback interface (`127.0.0.1:8090`).
- **Secret Isolation:** Environment secrets are managed via Git-ignored `.env.compose` with strict exclusions in `.gitignore`.
- **State Protection:** Sensitive Terraform state (`*.tfstate`) and binary plan files (`*.tfplan`) are excluded from version control.
- **Provider Pinning:** Terraform provider versions are strictly locked in `main.tf` and `.terraform.lock.hcl`.

## Documentation

- [`APPLICATION.md`](APPLICATION.md) — Concise project and architecture overview
- [`DEVOPS-TASK1.md`](DEVOPS-TASK1.md) — Task 1: Containerization and GitHub Actions CI/CD
- [`DEVOPS-TASK2.md`](DEVOPS-TASK2.md) — Task 2: Jenkins CI/CD on AWS EC2 with Docker Hub publishing
- [`DEVOPS-TASK3.md`](DEVOPS-TASK3.md) — Task 3: Infrastructure as Code with Terraform and Docker
- [`evidence/terraform/renewgrid/`](evidence/terraform/renewgrid/) — Task 3 Terraform execution plans, service verifications, and screenshots
- [`evidence/jenkins/jenkins-verification.md`](evidence/jenkins/jenkins-verification.md) — Task 2 verified execution record

## Scope

This project is an internship demonstration. It illustrates Infrastructure as Code concepts for local reproducible environments. Production operation would introduce remote encrypted Terraform state (e.g. AWS S3 + DynamoDB), dedicated cloud resources (VPC, ECS/EKS or EC2), automated rollback policies, and TLS termination.

## Author

Aoun Md.