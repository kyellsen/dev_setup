# Dev Environment Setup

This repository contains the infrastructure-as-code configuration for my personal development environment.
It enforces a strict separation between **Source Code** (Git), **Persistent Data** (Nextcloud), and **Ephemeral Workspaces** (Docker volumes).

## 📂 Targeted Architecture

The script enforces the following structure on `/mnt/data`:

| Path | Purpose | Backup Policy |
| :--- | :--- | :--- |
| `/mnt/data/dev` | **Source Code Library** (Git repositories) | ✅ Borg Backup |
| `/mnt/data/dev_workspaces` | **Ephemeral Labs** (Build artifacts, temp DBs) | ❌ No Backup |
| `/mnt/data/dev/_setup` | This configuration repository | ✅ Borg Backup |

## 🚀 Bootstrap on a New Machine

### 1. Prerequisites
Ensure you have a generic storage location available at `/mnt/data`.
If you are on a single-partition system (e.g., Laptop), create the directory manually:

```bash
sudo mkdir -p /mnt/data
sudo chown $USER:$USER /mnt/data
```

### 2. Installation

Clone this repository directly into its designated location:

```
# 1. Prepare the directory
mkdir -p /mnt/data/dev/_setup

# 2. Clone the repo
git clone git@github.com:kyellsen/dev_setup.git /mnt/data/dev/_setup

# 3. Run the setup script
sudo /mnt/data/dev/_setup/setup_env.sh
```

### 3. Maintaince

This script is idempotent. You can run it anytime to:

- Repair directory permissions.
- Create missing subdirectories.
- Restore folder icons.

```
sudo /mnt/data/dev/_setup/setup_env.sh
```



