# GitHub Actions Workflow Templates

These workflow templates enable Droid-powered automation for your projects.

## Available Workflows

### droid-pr-review.yml

Automatically reviews pull requests using Droid with your project's `.droid.yaml` configuration.

**Triggers**: PR opened, synchronized, or reopened

**Setup**:

1. Copy `droid-pr-review.yml` to your project's `.github/workflows/`
2. Add `FACTORY_API_KEY` to your repository's Actions secrets
3. Ensure `.droid.yaml` exists in your project root (use `project/.droid.yaml` as a template)

### droid-scheduled-audit.yml

Runs weekly security and architecture audits, creating GitHub issues for findings.

**Triggers**: Weekly cron (Monday 9am UTC) or manual dispatch

**Setup**:

1. Copy `droid-scheduled-audit.yml` to your project's `.github/workflows/`
2. Add `FACTORY_API_KEY` to your repository's Actions secrets
3. Create `security` and `architecture` labels in your repository
4. Ensure the `security-auditor` and `architect` droids are available (install globally or in `.factory/droids/`)

## Prerequisites

All workflows require:

- A Factory.AI account with API access
- `FACTORY_API_KEY` repository secret
- Droid CLI (installed automatically by the workflows)

## Customization

Edit the workflow files to:

- Change the cron schedule for audits
- Add or remove audit types
- Modify issue labels
- Add notification steps (Slack, email, etc.)
