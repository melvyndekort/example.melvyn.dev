# example.melvyn.dev

> For global standards, way-of-workings, and pre-commit checklist, see `~/.claude/CLAUDE.md`

## Role

Web developer and DevOps engineer.

## What This Does

Example static website hosted on S3 with CloudFront CDN. Uses dual AWS regions (eu-west-1 + us-east-1 for ACM certificates).

## Repository Structure

- `src/` — Static site source
- `terraform/` — S3 bucket, CloudFront distribution, ACM certificate, DNS
- `Makefile` — `apply` (terraform), `deploy` (S3 sync)

## Terraform Details

- Backend: S3 key `example-melvyn-dev.tfstate` in `mdekort-tfstate-075673041815`
- Providers: AWS (two regions), Cloudflare
- Uses `useast1` provider alias for ACM certificates
- **Still in the management account.** Priority 4 subaccount migration
  candidate, paired with `startpage` into one shared "static-web" account —
  see `~/.claude/references/subaccount-migration.md`.

## Related Repositories

- `~/src/melvyndekort/tf-cloudflare` — DNS and API tokens
