---
name: hacker-ui
description: Build a terminal UI ("hacker UI") with a specific opinionated visual style — tab bar with `[N]` numeric hotkeys, orange uppercase section headers, bordered panels, indexed list rows, discrete adjustment controls, status bar at top, `? Help  q Quit` at bottom. Ships over SSH, runs in any terminal, no browser, no HTTP, no dependencies on a window manager. Use when the user asks to "build a TUI", "add a hacker UI", "make a terminal interface", "Textual app", "Bubble Tea app", or `/hacker-ui` for any tool, script, or service. Default to Python (Textual + Rich) when the user will read the code; Go (Bubble Tea + Lipgloss + Bubbles) when they want a single binary and don't care about the source.
---

# hacker-ui — terminal UIs that ship over SSH

The point: a well-built TUI is a power tool. Zero browser, zero HTTP, zero JS, runs over SSH and inside a tmux session unchanged. Quick number-key tab nav, single binary or single script, instantaneous render. Designed by developers for developers who know that less is so much more.

This skill is opinionated on purpose. The result is a UI that feels familiar across every tool that ships in this style — same skeleton, same keybindings, same color vocabulary. Ship-and-forget consistency.

---

## Canonical look (must match)

Every hacker-ui app has these layers, top to bottom:

```
┌──────────────────────────────────────────────────────────────────────────┐
│  AppName — vX.Y.Z   [green]●[/] connected   /dev/tty.usbmodem123451      │  ← title bar
├──────────────────────────────────────────────────────────────────────────┤
│  Dashboard [1]  Keys [2]  WLED [3]  Effects [4]  Stats [5]  Log [6]      │  ← tab bar (active tab underlined)
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Short one-or-two-line description of what this tab does.                │  ← tab description
│                                                                          │
│  EFFECT                                                                  │  ← uppercase orange section header
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │  0  off            static                                         │   │  ← indexed list row
│  │  1  rainbow-chase  hand-rolled                                    │   │
│  │  9  fire           hand-rolled       ← active row, inverted bg    │   │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  KNOBS                                                                   │
│  Speed:    [ -25 ][ -1 ][ +1 ][ +25 ]   ████████░░░░░  128 / 255         │  ← discrete steps + progress bar
│                                                                          │
├──────────────────────────────────────────────────────────────────────────┤
│  ? Help   q Quit                                            ^p palette   │  ← help bar (left: global, right: chord hints)
└──────────────────────────────────────────────────────────────────────────┘
```

Reference: the user's `DC29 Badge` app embodies this look exactly. If they share a screenshot, treat it as the canonical reference and match it.

---

## Color palette (mandatory)

Pick one terminal-safe accent and stick to it. Default below — only deviate if the user picks a brand color.

| Role            | Color (rough)         | Used for                                              |
|-----------------|-----------------------|-------------------------------------------------------|
| Accent          | orange / amber `214`  | Section headers, active widget border, primary CTAs   |
| Status OK       | green `green3` / `42` | Connected, on, healthy                                |
| Status warn     | yellow `yellow3`      | Degraded, pending                                     |
| Status err      | red `red3`            | Disconnected, off, failed                             |
| Dim text        | grey `grey50`         | Labels, helper hints                                  |
| Bright text     | white / default fg    | Values, list rows, body                               |
| Selected row bg | accent at low alpha   | Inverted accent for the active list row               |

Never use light-on-light or dark-on-dark. Test on a default macOS Terminal.app and a default Linux xterm before declaring done.

---

## Keybindings (mandatory contract)

| Key                | Action                                                                |
|--------------------|-----------------------------------------------------------------------|
| `1`–`9` (and `0`)  | Switch to tab with that number. **Tab labels MUST end with `[N]`.**   |
| `?`                | Toggle help overlay                                                   |
| `q` / `ctrl+c`     | Quit                                                                  |
| `tab` / `shift+tab`| Cycle focus between widgets within the active tab                     |
| arrow keys         | Move within a list / panel                                            |
| `enter`            | Activate / apply the focused row or button                            |
| `esc`              | Cancel / dismiss overlay or modal                                     |
| `ctrl+<letter>`    | Power-user chords — show in bottom-right help bar (e.g. `^p palette`) |

Bare digits switch tabs. Modifier+digit (`cmd+1`) is for the host terminal's own tabs (iTerm, tmux) — that's outside the app and you must not bind it.

---

## Required structural rules

- **Tab labels end with `[N]`.** Always. The `[N]` is what trains the user that the digit hotkey works.
- **Active tab is visually distinct.** Default: underline + accent color. Inactive tabs are dim text, no underline.
- **Section headers are UPPERCASE, accent color, no border, no padding above content.** One blank line between sections.
- **Borders are single-line by default.** Use heavy/double borders only on the focused widget if focus needs reinforcement.
- **Lists have a numeric index column.** The selected row is the accent color used as background, with text inverted to readable contrast.
- **Numeric controls have discrete adjustment buttons** in the form `-25  -1  +1  +25` (pick steps that suit the range), followed by a progress bar showing `current / max`. Up/down arrows on a focused control should adjust by the small step (`-1` / `+1`).
- **Status indicators are filled circles** (`●`) followed by a one-word state, colored by state. Never just colored text without the dot — the dot scans faster.
- **Help bar always visible.** Left: globals (`? Help  q Quit`). Right: chord hints contextual to the active tab (`^p palette`, `^r reload`, etc.). Never hide it.
- **Works in 80×24.** Word-wrap long descriptions. Truncate long values with an ellipsis. No horizontal scrolling.
- **No mouse-only flows.** Every interaction is reachable from the keyboard.

---

## Workflow when invoked

When the user asks for a hacker-ui:

### 1. Confirm scope

Briefly state what you understood:

- What tool / script is this a UI for?
- Which language — Python or Go?
- What tabs / sections does it need? (Propose 3–6 tabs based on the underlying tool.)

If the user didn't specify a language, ask once. Otherwise default per below.

### 2. Default language pick

- **Go** (Bubble Tea + Lipgloss + Bubbles) — vibe-coded one-shot tools, single-binary distribution, the user explicitly says they don't plan to read the code.
- **Python** (Textual + Rich) — the user is going to read or maintain it; rich widgets needed quickly; integrates with an existing Python project.

When in doubt, ask once.

### 3. Sketch the tabs

Before writing code, list the tabs as a bulleted plan: `Name [N]` — what it shows — what the user can do here. Keep it to one line each. Ask for confirmation if the underlying tool's domain is ambiguous.

### 4. Build it

Produce the implementation. Pin dependency versions. Wire up:

- Title bar with app name, version, status dot, contextual right-side info
- Tab bar with `[N]` suffixes, digit hotkeys, active-tab underline
- Tab description line
- Section headers (uppercase, accent)
- Bordered panels for content
- The actual widgets the tab needs (lists, knobs, sparklines, log tail, etc.)
- Help bar at the bottom

### 5. Run command

Always end with the exact command to run it: `python app.py` / `uv run app.py` / `go run .` / `go build && ./app`. If it talks to a serial port, an SSH host, or anything stateful, document the env vars or flags in the same line.

### 6. Show how to add a new tab

A 4–5 line snippet showing how to extend with a new tab. The user is going to keep building on this; make it obvious where to plug in.

---

## Python stack — Textual + Rich

```toml
# requirements.txt
textual>=0.80
rich>=13.0
```

Skeleton (paste this shape into any new app):

```python
from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, TabbedContent, TabPane, Static
from textual.binding import Binding

ACCENT = "orange3"

class HackerApp(App):
    CSS = """
    Tabs > Tab.-active { color: orange3; text-style: underline; }
    .section-header { color: orange3; text-style: bold; padding: 1 0 0 0; }
    .help-bar { dock: bottom; height: 1; background: $panel; }
    """
    BINDINGS = [
        Binding("1", "show_tab('dashboard')", "Dashboard", show=False),
        Binding("2", "show_tab('keys')",      "Keys",      show=False),
        Binding("3", "show_tab('wled')",      "WLED",      show=False),
        Binding("q", "quit",                  "Quit"),
        Binding("question_mark", "help",      "Help"),
    ]

    def compose(self) -> ComposeResult:
        yield Header(show_clock=False)
        with TabbedContent(initial="dashboard"):
            with TabPane("Dashboard [1]", id="dashboard"):
                yield Static("Short description of this tab.\n")
                yield Static("STATUS", classes="section-header")
                # ... widgets
            with TabPane("Keys [2]", id="keys"):
                yield Static("Hotkeys reference.\n")
            with TabPane("WLED [3]", id="wled"):
                yield Static("Pick an effect, palette, knobs.\n")
        yield Footer()

    def action_show_tab(self, tab_id: str) -> None:
        self.query_one(TabbedContent).active = tab_id

if __name__ == "__main__":
    HackerApp().run()
```

Tips:
- `Footer` auto-shows visible bindings; use `show=False` on tab-switch bindings so the footer stays clean and only shows globals (`q Quit`, `? Help`) and contextual chords.
- For knobs: combine `Button` rows (`-25` `-1` `+1` `+25`) with a `ProgressBar`.
- For status dot in the header: subclass `Header` or use a custom `Static` with `[green]●[/] connected`.

## Go stack — Bubble Tea + Lipgloss + Bubbles

```go
// go.mod
require (
    github.com/charmbracelet/bubbletea v0.27.0
    github.com/charmbracelet/lipgloss v0.13.0
    github.com/charmbracelet/bubbles v0.20.0
)
```

Skeleton:

```go
package main

import (
    "fmt"
    "os"
    tea "github.com/charmbracelet/bubbletea"
    "github.com/charmbracelet/lipgloss"
)

var (
    accent     = lipgloss.Color("214")
    dim        = lipgloss.Color("245")
    headerStyle = lipgloss.NewStyle().Foreground(accent).Bold(true)
    activeTab   = lipgloss.NewStyle().Foreground(accent).Underline(true)
    inactiveTab = lipgloss.NewStyle().Foreground(dim)
)

type tab struct{ name, body string }

type model struct {
    tabs   []tab
    active int
}

func (m model) Init() tea.Cmd { return nil }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
    if k, ok := msg.(tea.KeyMsg); ok {
        switch k.String() {
        case "q", "ctrl+c":
            return m, tea.Quit
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            i := int(k.Runes[0] - '1')
            if i < len(m.tabs) {
                m.active = i
            }
        }
    }
    return m, nil
}

func (m model) View() string {
    var bar string
    for i, t := range m.tabs {
        label := fmt.Sprintf("%s [%d]", t.name, i+1)
        if i == m.active {
            bar += activeTab.Render(label) + "  "
        } else {
            bar += inactiveTab.Render(label) + "  "
        }
    }
    body := m.tabs[m.active].body
    help := lipgloss.NewStyle().Foreground(dim).Render("? Help   q Quit")
    return bar + "\n\n" + body + "\n\n" + help
}

func main() {
    m := model{tabs: []tab{
        {"Dashboard", headerStyle.Render("STATUS") + "\nrunning"},
        {"Keys",      headerStyle.Render("HOTKEYS") + "\n1-9 switch tabs"},
        {"Stats",     headerStyle.Render("STATS") + "\n..."},
    }}
    if _, err := tea.NewProgram(m, tea.WithAltScreen()).Run(); err != nil {
        fmt.Println(err); os.Exit(1)
    }
}
```

Tips:
- Use `tea.WithAltScreen()` so the TUI takes the full terminal and exits cleanly without leaving artifacts.
- `lipgloss.Place` for centered overlays; `lipgloss.JoinHorizontal` / `JoinVertical` for layout.
- Prefer `bubbles/list`, `bubbles/progress`, `bubbles/textinput` over rolling your own.

---

## What to avoid

- ❌ **Tabs without `[N]` suffix** — breaks the digit-hotkey contract.
- ❌ **Mouse-only flows** — every action must have a keyboard path.
- ❌ **Animated splash screens / fade transitions** — this ships over SSH; lag is poison.
- ❌ **Browser or HTTP server dependencies** — defeats the entire pitch.
- ❌ **More than one primary action per tab** — each tab does one thing well.
- ❌ **Hidden keybindings** — every binding must be discoverable from `?` help or the bottom bar.
- ❌ **Wide tables or text without wrap** — must work in 80×24.
- ❌ **Inventing colors** — pick the accent once, reuse everywhere. No rainbow chrome.
- ❌ **Modal dialogs that block input** for trivial confirmations — use a status line message instead.
- ❌ **Logging to stdout while the TUI is running** — it'll trash the render. Log to a file or to an in-app log tab.

---

## Drift prevention checklist

Before declaring done, verify:

- [ ] Title bar shows app name, version, status dot, context info
- [ ] Every tab label ends with `[N]`
- [ ] Digits `1`–`9` switch tabs without modifiers
- [ ] Active tab is visually distinct (underline + accent)
- [ ] Section headers are UPPERCASE in accent color
- [ ] Lists have numeric index columns; selected row is inverted accent
- [ ] Numeric knobs have `-N`/`-1`/`+1`/`+N` buttons + progress bar
- [ ] Status dots use `●` with a one-word state
- [ ] Bottom bar shows `? Help  q Quit` plus contextual chord hints
- [ ] Renders correctly at 80×24
- [ ] No browser, no HTTP server, no GUI toolkit dependencies
- [ ] `q` and `ctrl+c` both quit cleanly
- [ ] Run command is documented in the final reply
