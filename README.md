# Dev Environment Setup

This repository contains the infrastructure-as-code for my personal development environment.
It enforces a strict separation between **Source Code** (Git), **Persistent Data** (Nextcloud), and **Ephemeral Workspaces** (local, no backup).

## 📂 Targeted Architecture

The setup script enforces the following structure on `/mnt/data`:

| Path | Purpose | Backup |
|:---|:---|:---|
| `/mnt/data/dev/` | Source code library (Git repos) | ✅ Borg |
| `/mnt/data/dev/projects/` | Data analysis & research projects | ✅ Borg |
| `/mnt/data/dev/_templates/` | Project scaffolding templates | ✅ Borg |
| `/mnt/data/dev_workspaces/` | Ephemeral artifacts (Parquet, plots) | ❌ None |
| `/mnt/data/kyellsen/300_Projekte/` | Raw data & project docs | ✅ Nextcloud |

## 🔑 Key Principles

- **No raw data in Git.** Use `.env` files to point projects at Nextcloud data paths.
- **Workspaces are ephemeral.** Every result can be regenerated from raw data + code.
- **Project scaffolding** via [copier](https://copier.readthedocs.io/) from `/mnt/data/dev/_templates/copier_project`.

## 🚀 Bootstrap on a New Machine

### 1. Prerequisites

Ensure storage is mounted at `/mnt/data`:

```bash
sudo mkdir -p /mnt/data
sudo chown $USER:$USER /mnt/data
```

### 2. Installation

```bash
# 1. Prepare the directory
mkdir -p /mnt/data/dev/_setup

# 2. Clone the repo
git clone git@github.com:kyellsen/dev_setup.git /mnt/data/dev/_setup

# 3. Run the setup script
sudo /mnt/data/dev/_setup/setup_env.sh
```

### 3. Maintenance

The script is idempotent — safe to re-run anytime to repair permissions or create missing dirs:

```bash
sudo /mnt/data/dev/_setup/setup_env.sh
```
