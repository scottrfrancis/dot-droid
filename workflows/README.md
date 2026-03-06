# GitHub Actions Workflow Templates

These workflow templates enable Droid-powered automation for your projects. They're not installed automatically — you copy them into each project that needs them.

## Available Workflows

### droid-pr-review.yml

Automatically reviews every pull request using Droid with your project's `.droid.yaml` configuration.

**What it does**: On every PR (opened, updated, or reopened), Droid reviews the diff and posts inline comments — similar to a human code review but checking against your `.droid.yaml` guidelines.

**Triggers**: `pull_request` events (opened, synchronize, reopened)

**End-to-end setup for a project**:

```bash
# 1. Make sure the project has .droid.yaml (the install script does this)
cd /Volumes/workspace/dot-droid
./install.sh /Volumes/workspace/catalyst-rcm-dashboard-bot

# 2. Copy the workflow file
cd /Volumes/workspace/catalyst-rcm-dashboard-bot
mkdir -p .github/workflows
cp /Volumes/workspace/dot-droid/workflows/droid-pr-review.yml .github/workflows/

# 3. Add your Factory API key as a GitHub Actions secret
#    Browser: https://github.com/scottfrancis/catalyst-rcm-dashboard-bot/settings/secrets/actions
#    Or CLI:
gh secret set FACTORY_API_KEY --body "fak_your_api_key_here"

# 4. Commit and push
git add .droid.yaml .github/workflows/droid-pr-review.yml
git commit -m "ci: add Droid PR review automation"
git push
```

**What PR reviews look like**: Droid posts inline comments on the diff, like:

> **src/auth/middleware.ts:42** — Missing null check on `req.user.customerId` before tenant validation. An unauthenticated request that slips past the auth guard will throw `TypeError`.
>
> **docker-compose.yml:15** — Port `5432` is bound to `0.0.0.0`. Bind to `127.0.0.1:5432:5432` to prevent direct database access from outside the Docker host.

The review rules come from your `.droid.yaml`. For example, the default template includes:

```yaml
guidelines:
  - path: "**/*.sh"
    instructions: "Check for set -euo pipefail, SCRIPT_DIR detection, proper quoting."
  - path: "**/docker-compose*.yml"
    instructions: "Check port bindings (prefer 127.0.0.1), volume mounts, and secret handling."
```

### droid-scheduled-audit.yml

Runs weekly security and/or architecture audits and opens GitHub issues with findings.

**What it does**: Every Monday at 9am UTC (or on manual trigger), runs the `security-auditor` and `architect` droids against your codebase and creates GitHub issues for findings.

**Triggers**: Weekly cron or manual `workflow_dispatch`

**End-to-end setup**:

```bash
cd /Volumes/workspace/catalyst-rcm-dashboard-bot

# 1. Copy the workflow
cp /Volumes/workspace/dot-droid/workflows/droid-scheduled-audit.yml .github/workflows/

# 2. Ensure FACTORY_API_KEY secret exists (from PR review setup, or:)
gh secret set FACTORY_API_KEY --body "fak_your_api_key_here"

# 3. Create issue labels (one-time)
gh label create security --color d73a4a --description "Security audit findings"
gh label create architecture --color 0075ca --description "Architecture review findings"
gh label create automated-audit --color e4e669 --description "Created by Droid scheduled audit"

# 4. Commit and push
git add .github/workflows/droid-scheduled-audit.yml
git commit -m "ci: add Droid scheduled audit workflow"
git push
```

**Trigger manually** (e.g., before a release):

```bash
# Run security audit only
gh workflow run "Droid Scheduled Audit" --field audit_type=security

# Run architecture review only
gh workflow run "Droid Scheduled Audit" --field audit_type=architecture

# Run both (default for cron)
gh workflow run "Droid Scheduled Audit" --field audit_type=both
```

**What the issues look like**: The workflow creates GitHub issues titled "Security Audit Findings - 2026-03-06" with the full audit report as the issue body, labeled `security` + `automated-audit`.

## Prerequisites

All workflows require:

- **Factory.AI account** — sign up at [factory.ai](https://factory.ai)
- **API key** — get from [app.factory.ai/settings](https://app.factory.ai/settings), stored as `FACTORY_API_KEY` repository secret
- **Droid CLI** — installed automatically by the workflows (via `curl -fsSL https://app.factory.ai/cli | sh`)

## Customization

### Change the audit schedule

Edit the cron expression in `droid-scheduled-audit.yml`:

```yaml
on:
  schedule:
    # Every weekday at 6am UTC
    - cron: '0 6 * * 1-5'
    # First of every month
    # - cron: '0 9 1 * *'
```

### Add Slack notifications

Add a step after the issue creation:

```yaml
      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {"text": "Droid audit completed. Check issues: ${{ github.server_url }}/${{ github.repository }}/issues"}
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Skip reviews for draft PRs

Add a condition to the PR review job:

```yaml
jobs:
  review:
    if: github.event.pull_request.draft == false
    runs-on: ubuntu-latest
```

## Related Documentation

- [Factory.AI GitHub Integration](https://docs.factory.ai/integrations/github-actions) (if available)
- [.droid.yaml Configuration](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration)
- [Custom Droids](https://docs.factory.ai/cli/configuration/custom-droids)
