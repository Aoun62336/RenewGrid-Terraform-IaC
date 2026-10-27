# Contributing to RenewGrid

This repository uses a pull-request-based Git workflow to manage application, infrastructure, and documentation changes.

## Branching Strategy

| Branch      | Purpose                                 |
| ----------- | --------------------------------------- |
| `main`      | Stable, approved project state          |
| `dev`       | Integration of validated changes        |
| `feature/*` | Individual development improvements     |
| `fix/*`     | Non-emergency corrections               |
| `hotfix/*`  | Urgent fixes based on the stable branch |

Feature and fix branches normally start from `dev`.

Changes are integrated into `dev` through pull requests. Validated changes are promoted from `dev` to `main` through a release pull request.

Urgent fixes may be proposed directly to `main` through a hotfix pull request. Accepted hotfixes must also be incorporated into `dev`.

## Commit Conventions

Use concise, descriptive commit messages.

Examples:

- `feat: add application capability`
- `fix: correct validation failure`
- `docs: update deployment instructions`
- `ci: improve workflow validation`
- `chore: update repository configuration`
- `test: extend regression coverage`

Keep commits focused on one logical change.

## Pull Request Process

1. Synchronize the appropriate base branch.
2. Create a short-lived feature or fix branch.
3. Make and review the changes.
4. Run relevant local checks.
5. Push the branch and create a pull request.
6. Wait for the required GitHub Actions checks.
7. Review the changes before merging.
8. Update the local integration branch after merging.

Pull requests must describe the change, validation performed, and relevant risks.

## Required Validation

The repository uses GitHub Actions for:

- Application validation and secret scanning
- Terraform formatting and configuration validation
- Docker Compose configuration validation

All configured required checks must pass before integration.

## Release Management

1. Integrate completed changes into `dev`.
2. Open a release pull request from `dev` to `main`.
3. Verify required checks.
4. Merge the approved release.
5. Update the changelog as part of release preparation.
6. Create an annotated version tag on the released commit.
7. Verify the tag and publish a GitHub Release.

Release tags follow the format `vMAJOR.MINOR.PATCH`.

## Safety

- Never commit credentials or local environment files.
- Never commit Terraform state or saved execution plans.
- Avoid force-pushing protected branches.
- Use `git revert` through a pull request to reverse changes already published to shared branches.
- Avoid rewriting published release history.

## Project Scope

This workflow is implemented for the Elevate Labs DevOps Internship Task 4.

The repository retains the application and infrastructure work completed in previous tasks.
