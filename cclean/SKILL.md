---
name: cclean
description: Check if the `cclean` command is installed and reachable in PATH. `cclean` cleans Claude Code terminal output by stripping ❯ prompts and joining wrapped lines — useful for pasting into Slack or iMessage. Run this to verify the install or fix a missing/broken one.
---

# cclean

Checks whether `cclean` is installed and reachable, and installs it if not.

## What `cclean` does

`cclean` cleans up Claude Code terminal output:
- Strips leading `❯` prompt characters
- Joins wrapped lines into clean paragraphs
- Collapses extra whitespace

**Clipboard mode** (no pipe): reads from clipboard, writes cleaned text back to clipboard, prints to stdout.  
**Pipe mode**: `pbpaste | cclean` reads stdin, writes stdout.

## Steps

### 1. Check if `cclean` is reachable

```bash
command -v cclean
```

If the command is found, print the path and confirm it's working:

```bash
cclean --help 2>&1 || echo "(no --help flag; run 'cclean' with clipboard content to test)"
```

Report to the user: installed at `<path>`, ready to use.

### 2. If not found — install it

Run the install script bundled with this skill:

```bash
bash ~/.claude/skills/cclean/install.sh
```

The install script:
1. Copies `cclean.py` to `~/.local/bin/cclean`
2. Makes it executable
3. Warns if `~/.local/bin` is not in `PATH`

### 3. If `~/.local/bin` is not in PATH

Tell the user to add this line to their shell rc file (`~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:

```bash
source ~/.zshrc   # or ~/.bashrc
```

### 4. Verify after install

```bash
command -v cclean && echo "cclean is ready"
```

## Usage reminder

Once installed:

```
cclean              # reads clipboard, cleans, writes back to clipboard
pbpaste | cclean    # pipe mode
```
