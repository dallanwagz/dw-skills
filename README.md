# dw-skills

My curated list of skills that I use in my Claude Code workflows.

## Installation

Clone this repo and rsync the skills to `~/.claude/skills/`:

```bash
git clone https://github.com/dallanwagz/dw-skills.git ~/repo/dw-skills
```

Then use the `sync-skills` skill to keep them current, or rsync manually:

```bash
REPO=~/repo/dw-skills
DEST=~/.claude/skills

for skill_dir in "$REPO"/*/; do
  name=$(basename "$skill_dir")
  rsync -a --exclude='.git/' "$skill_dir" "$DEST/$name/"
done
```

## Skills

| Skill | Description |
|---|---|
| `sync-skills` | Pull latest skills from a GitHub repo and install to `~/.claude/skills/` |
| `analyze-notebook-outputs` | Export a Databricks notebook with outputs, update markdown commentary, re-import without killing renders |
| `regen-docs` | Regenerate documentation from a spine config |
| `dc29-add-app` | Wizard for adding a new app profile to a DC29 button config |
| `cclean` | Check/install `cclean` — strips `❯` prompts and joins wrapped lines for clean Slack/iMessage pastes |
| `dei-review` | Package the current prompt + proposed solution as a peer-review request to paste into a *different* LLM, then integrate the feedback critically. Diversity of models, not the HR sense of DEI. |
| `soft_skills/` | Leadership, management, and strategy skills |
