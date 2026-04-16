---
name: "md2pdf"
description: "Build professional PDFs from ordered markdown sections using report.yaml config and WeasyPrint"
---

# md2pdf: Markdown-to-PDF Generation

Config-driven tool for assembling ordered markdown sections into a styled PDF.
Installed at `~/.local/bin/md2pdf`. Source of truth: `~/dot-claude/commands/build-pdf.md`.

## When to Use

- User asks to "build a PDF", "generate a report", or "make a PDF from markdown"
- A project has a `report.yaml` in its root
- User wants to set up PDF generation for a new project

## The Tool

`md2pdf` reads `report.yaml` from the project root and:
1. Combines markdown sections in order
2. Converts to HTML via python-markdown (tables, extra, sane_lists extensions)
3. Applies CSS (embedded default or project override)
4. Renders to PDF via WeasyPrint

## Quick Reference

```bash
md2pdf                      # build from ./report.yaml
md2pdf path/to/report.yaml  # explicit config
md2pdf --init               # scaffold a report.yaml
```

## Config Format (report.yaml)

```yaml
title: My Report
footer: "Footer text for each page"
output: report/output.pdf
sections:
  - report/01-intro.md
  - report/02-body.md
css: optional/override.css      # optional, replaces default styles
combined: report/_combined.md   # optional, writes merged markdown
```

## Dependencies

- `weasyprint` (Homebrew: `brew install weasyprint`)
- `markdown` (pip: `pip3 install markdown`)
- Optionally `PyYAML` (pip: `pip3 install pyyaml`) -- falls back to built-in parser

## Default CSS

The embedded CSS uses EY brand-inspired styling: Arial 9pt body, dark headers
(`#2E2E38`), yellow accents (`#FFE600`), letter-size pages, 0.75in margins.
Projects can override entirely via the `css` key in report.yaml.

## Setting Up a New Project

1. Run `md2pdf --init` in the project root
2. Edit `report.yaml`: set title, footer, output path, section list
3. Run `md2pdf` to build
