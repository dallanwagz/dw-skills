---
name: dc29-add-app
version: 1.0.0
description: |
  Wizard that proposes a 4-button profile for a new app in the DC29 badge
  macro-keypad system and — after user approval — writes the PageDef into
  dc29/bridges/registry.py and inserts it into ALL_PAGES at the right priority.
  Invoke as: /dc29-add-app <app-name>
allowed-tools:
  - Read
  - Edit
  - Bash
---

# DC29 Add-App Wizard

When this skill is invoked the user provides an app name (e.g. `/dc29-add-app Spotify`).
If no app name is given, ask for one before proceeding.

---

## Context you must read first

Read these files before proposing anything:

| File | Why |
|------|-----|
| `dc29/bridges/registry.py` | Full registry — existing PageDefs, helpers `_a` / `_same`, `ALL_PAGES` list |
| `dc29/bridges/generic.py` | `PageDef` / `ActionDef` dataclasses and `_press_shortcut` key-name rules |
| `dc29/bridges/colors.py` | `POSITION_ACTIVE` colors for reference |

---

## Positional semantics — ENFORCE THESE, no exceptions

Every page must follow this layout. The whole point of the system is consistent muscle memory across 15+ apps.

| Button | Color   | Semantic family                                      |
|--------|---------|------------------------------------------------------|
| B1     | Warm red (220, 35, 0)  | **Destructive / exit / undo / delete / close**   |
| B2     | Cool blue (0, 80, 220) | **Status / visibility / toggle / communicate**   |
| B3     | Amber (200, 140, 0)    | **Navigate / find / search / jump**              |
| B4     | Green (0, 175, 50)     | **Create / save / confirm / generate**           |

If the app doesn't have an obvious action for a slot, pick the closest analogue — a slightly imperfect semantic fit is *fine* as long as the positional rule holds.  Never swap slots to make semantics "cleaner".

---

## Steps

### 1. Classify the app

Is it:
- **Native desktop app** — has its own process (VS Code, Figma, Notion, Word) → `match_names` = process name substrings, `match_window_title=False`
- **Web app** — runs as a browser tab (Jira, GitHub, ChatGPT, Claude) → `match_names` = title-bar substrings that appear in the tab, `match_window_title=True`

### 2. Research shortcuts

Think about the 8–10 most common keyboard shortcuts for this app. For each positional slot, pick the best fit:

- B1: What's the primary "undo" / "close" / "exit" / "delete" action?
- B2: What toggles something visible — sidebar, formatting panel, preview, status indicator?
- B3: What opens search / find / command palette / quick nav?
- B4: What saves, creates, submits, or confirms something?

Note Mac vs Windows differences (`cmd` vs `ctrl`, etc.).

### 3. Choose brand color

Pick an (R, G, B) that matches the app's brand or primary UI color. This is used for the context-switch flash animation (2× blink when the app gains focus). Keep it recognizable but not so dark it's invisible or so bright it's blinding.

Avoid:
- `(255, 255, 255)` — Notion got this, it flashes invisible/white-out
- `(0, 0, 0)` or any near-black — will not flash
- Pure saturated colors are fine (`(66, 133, 244)` for Chrome blue, `(162, 89, 255)` for Figma purple)

### 4. Determine `match_names`

- **Native**: lowercase process name(s) that appear in `_get_active_app()` output. Test with: `osascript -e 'tell app "System Events" to get name of first process whose frontmost is true'`
- **Web**: lowercase substrings that uniquely appear in the browser tab title when using this app. Should NOT match other sites. For example `"jira"` matches `"PROJ-123 · Jira"`, `"github.com"` would match too broadly — prefer `"github"`.

Use multiple entries if the app has aliases (e.g. `["code", "visual studio code"]`).

### 5. Determine priority placement in ALL_PAGES

All pages are installed as concurrent bridges; the list order sets hook-chain priority. First entry = lowest priority (outermost hook layer), last = highest.

Rules:
- Generic browser fallback (`CHROME`) → always first
- Web apps (`match_window_title=True`) → after Chrome, before native apps
- Native apps → at the end, highest priority
- Within each group: more general apps before more specific (e.g. WORD before VSCODE)

---

## Output format

Present your proposal like this:

```
APP: <App Name>
TYPE: native | web (window-title match)
BRAND COLOR: (R, G, B) — <why this color>
MATCH NAMES: ["<name1>", "<name2>"]

BUTTON LAYOUT:
  B1 [warm-red]  <action-label>   →  <Mac shortcut>  /  <Win shortcut>
  B2 [cool-blue] <action-label>   →  <Mac shortcut>  /  <Win shortcut>
  B3 [amber]     <action-label>   →  <Mac shortcut>  /  <Win shortcut>
  B4 [green]     <action-label>   →  <Mac shortcut>  /  <Win shortcut>

POSITIONAL RATIONALE:
  B1 — <why this action fits the destructive/exit/undo family>
  B2 — <why this action fits the status/visibility/toggle family>
  B3 — <why this action fits the navigate/find/search family>
  B4 — <why this action fits the create/save/confirm family>

REGISTRY ENTRY (preview):
<paste the full PageDef Python code>

ALL_PAGES PLACEMENT: insert at position N (after X, before Y) — <why>
```

Then ask: **"Does this look right? Any changes before I write it to registry.py?"**

---

## Writing to registry.py

Only write after explicit user approval. When writing:

1. Add the `PageDef` constant after related apps (native near native, web near web).
2. Insert the constant name into `ALL_PAGES` at the correct priority position.
3. Run `python3 -c "from dc29.bridges.registry import ALL_PAGES; print(f'{len(ALL_PAGES)} pages OK')"` to verify no import errors.

Report the final page count and confirm which slot the new app occupies.

---

## Key syntax rules for PageDef entries

```python
# Cross-platform shortcut (different on Mac vs Win):
_a("label", ["cmd"], "key", ["ctrl"], "key")
_a("label", ["cmd", "shift"], "key", ["ctrl", "shift"], "key")

# Same shortcut on both platforms:
_same("label", ["cmd"], "key")    # with modifier
_same("label", [], "escape")      # no modifier, special key
_same("label", [], "c")           # single char, no modifier

# Special key names (pynput Key.* — must be lowercase):
"escape", "backspace", "delete", "enter", "tab", "space",
"left", "right", "up", "down", "f1"–"f12",
"page_up", "page_down", "home", "end"

# Modifier names (valid values):
"cmd"   — ⌘ Command (Mac only; maps to Win key on Windows — usually don't use)
"ctrl"  — Control
"shift" — Shift
"alt"   — Option/Alt
```

---

## Drift prevention checklist

Before writing, verify every item:
- [ ] B1 action is destructive/exit/undo/close family
- [ ] B2 action is status/visibility/toggle/communicate family
- [ ] B3 action is navigate/find/search/jump family
- [ ] B4 action is create/save/confirm/generate family
- [ ] `brand_color` is visible (not near-black, not pure white)
- [ ] `match_names` substrings are lowercase
- [ ] `match_window_title=True` for web apps, absent/False for native
- [ ] Priority position is correct (web apps before native, general before specific)
- [ ] `_a` used when Mac/Win differ; `_same` when identical
- [ ] `python3 -c "from dc29.bridges.registry import ALL_PAGES"` passes clean
