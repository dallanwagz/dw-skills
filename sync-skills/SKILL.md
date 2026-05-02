---
name: sync-skills
description: Pull the latest skills from the dw-skills GitHub repo and install them to ~/.claude/skills/ so they're available in every Claude Code session. Run this to keep all custom skills up to date across machines or after a new skill is added to the repo.
---

# sync-skills

Syncs the latest custom skills from the `dw-skills` repo to `~/.claude/skills/`.

## What it does

1. Finds (or accepts) the local path to the cloned `dw-skills` repo
2. Runs `git pull` to get the latest
3. Copies all top-level skill directories (everything except `soft_skills/`, `README.md`, `.git`) to `~/.claude/skills/`
4. Reports what was added, updated, or unchanged

## Steps

### 1. Locate the repo

Check the known default first:

```bash
ls /Users/dallan/repo/dw-skills/README.md 2>/dev/null && echo "found"
```

If not found, ask the user: *"Where is the dw-skills repo cloned? (default: ~/repo/dw-skills)"*

### 2. Pull latest

```bash
git -C <REPO_PATH> pull
```

### 3. Sync skill directories to ~/.claude/skills/

Copy all top-level directories except `soft_skills/`:

```bash
REPO=<REPO_PATH>
DEST=~/.claude/skills

for skill_dir in "$REPO"/*/; do
  name=$(basename "$skill_dir")
  # Skip soft_skills folder and any hidden dirs
  if [[ "$name" == "soft_skills" ]] || [[ "$name" == .* ]]; then
    continue
  fi
  rsync -a --exclude='.git/' --exclude='__pycache__/' --exclude='*.pyc' \
    "$skill_dir" "$DEST/$name/"
done
```

### 4. Optionally sync soft skills too

If the user asks to include soft skills (leadership/management/strategy):

```bash
for skill_dir in "$REPO/soft_skills"/*/; do
  name=$(basename "$skill_dir")
  rsync -a "$skill_dir" "$DEST/$name/"
done
```

### 5. Run any skill install scripts

After syncing, check for `install.sh` in each skill directory and run any that exist:

```bash
DEST=~/.claude/skills
for skill_dir in "$DEST"/*/; do
  if [[ -f "$skill_dir/install.sh" ]]; then
    name=$(basename "$skill_dir")
    echo "Running install.sh for $name..."
    bash "$skill_dir/install.sh"
  fi
done
```

### 6. Report

```bash
echo "Skills installed to ~/.claude/skills/:"
ls ~/.claude/skills/ | sort
```

Tell the user to restart Claude Code (or open a new session) for newly added skills to appear in autocomplete.

## Notes

- Existing skills are overwritten with the repo version — the repo is the source of truth
- `soft_skills/` is not synced by default (ask the user if they want them)
- Skills with supporting files are copied in full

## Repo

`https://github.com/dallanwagz/dw-skills`

Default local clone: `/Users/dallan/repo/dw-skills`
