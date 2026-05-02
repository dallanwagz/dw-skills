---
name: regen-docs
description: Generic documentation regeneration skill. Reads docs/spine/ (or equivalent source-of-truth directory), reads current source code, and regenerates all branch documentation directories. Works for any project with a spine+branches doc pattern.
---

You are regenerating branch documentation from a source-of-truth spine. This skill works for any project — it auto-detects the project type, spine location, and branch directories.

## Philosophy

Good documentation has two layers:
- **Spine (source of truth):** Written by humans, authoritative, never auto-generated. Contains the canonical reference for the project.
- **Branches:** Derived from the spine for specific audiences (users, developers, contributors, etc.). Can be regenerated to stay in sync.

Your job is to regenerate branch docs from the current spine + code state. Never modify spine files.

---

## Step 1: Auto-Detect Project Structure

Read the repository to understand what you're working with.

### Detect project type
Look for:
- `pyproject.toml`, `setup.py`, `setup.cfg` → Python package
- `Cargo.toml` → Rust
- `package.json` → JavaScript/TypeScript
- `CMakeLists.txt`, `Makefile`, `*.cproj` → C/C++
- `go.mod` → Go
- Mixed projects: note all types

### Detect spine location
Check for a source-of-truth documentation directory. Common names:
- `docs/spine/`
- `docs/source/`
- `docs/canonical/`
- `docs/reference/` (only if it contains numbered/ordered files)
- `src/docs/` (sometimes)

The spine directory typically contains numbered files (`00-`, `01-`, etc.) or clearly named reference files (`overview.md`, `protocol.md`, `architecture.md`, etc.).

If no spine directory is found, report this and stop.

### Detect branch directories
Look for directories under `docs/` that are NOT the spine. Common names:
- `docs/user/` or `docs/users/`
- `docs/developer/` or `docs/dev/`
- `docs/contributor/` or `docs/contributing/`
- `docs/hacker/`
- `docs/api/`
- `docs/getting-started/`
- Any directory with an audience-named `README.md`

If a branch directory doesn't exist yet but should (based on spine content or project type), create it.

### Detect source files to read
Find the primary source files that branch docs should reflect:

**Python:** `src/**/*.py`, package `__init__.py`, `pyproject.toml`  
**Rust:** `src/lib.rs`, `src/main.rs`, `Cargo.toml`  
**JavaScript/TypeScript:** `src/index.ts`, `src/index.js`, `package.json`  
**C/C++:** Primary `.h` header files, `CMakeLists.txt`

Focus on:
- Public API surface (exported functions/classes/types)
- Configuration constants
- Protocol or schema definitions
- Version numbers and dependency requirements

---

## Step 2: Read All Source Material

Read the spine documents in order. Read any source files relevant to what the docs describe. Do not skip files — inconsistencies arise from partial reads.

As you read, note:
- Any protocol/API definitions with specific values (byte sequences, enum values, etc.)
- Version numbers and compatibility requirements
- Platform-specific behavior (OS differences, etc.)
- Known limitations or pitfalls explicitly documented in the spine

---

## Step 3: Determine Branch Audiences and Regenerate

For each branch directory found (or that should exist), determine the target audience and regenerate accordingly.

### Audience patterns and their doc styles

**End users / non-technical:**
- Step-by-step numbered instructions
- No internal implementation details
- Concrete examples with real values (real port paths, real commands)
- Platform differences called out explicitly
- FAQ/troubleshooting section
- Never: hex byte values, source file names, compiler flags

**Developers / integrators:**
- Full API reference with type signatures
- Runnable code examples
- Async/threading model explained
- All constants with values
- Extension points documented

**Contributors / hackers:**
- Build system instructions in full detail
- Source file map
- Critical settings that must not be wrong
- How to add new features (step-by-step with code)
- Internal data formats (binary layouts, packed structs, etc.)

**API reference:**
- Automatically derived from source code
- Every public function, class, enum, constant
- Type information
- Return values and error conditions
- Usage examples

---

## Step 4: Write Branch Files

For each branch directory, write or overwrite these standard files:

**Always include:**
- `README.md` — landing page with: audience description, what's in this branch, links to all pages, quick start if applicable

**Per audience (generate what's relevant):**

| Audience | Typical files |
|----------|--------------|
| User | `setup.md`, `guide.md` or `tutorial.md`, `faq.md`, `customizing.md` |
| Developer | `api-reference.md`, `examples.md`, `integration.md` or `building-X.md` |
| Contributor/Hacker | `build.md`, `architecture.md`, `adding-X.md`, `hardware-ref.md` or `internals.md` |

**File header requirement:** Every generated branch file must start with this note after the title:

```markdown
> **Note:** This file is regenerated by the `/regen-docs` skill from the source-of-truth in `docs/spine/` (or equivalent). Do not hand-edit this file — edit the spine files instead and re-run `/regen-docs`.
```

**Also include:**
- Breadcrumb at top: `← Back to [Section Name](README.md)`
- Cross-links to related spine pages for readers who want the full reference

---

## Step 5: Style and Quality Guidelines

### Markdown
- GitHub-flavored Markdown
- Fenced code blocks with language tags (`bash`, `python`, `c`, `json`, etc.)
- Tables for reference material (protocol tables, option lists, config tables)
- Mermaid diagrams for architecture and flow diagrams where helpful
- Relative links between pages

### Content quality
- Every code example must be syntactically correct and actually runnable
- Platform differences (macOS/Windows/Linux) must be called out explicitly
- Warnings for destructive or irreversible operations (flashing firmware, resetting EEPROM, etc.)
- No TODO comments or placeholders in generated files

### Consistency
- All values (byte values, enum names, port names, version numbers) must match the spine and source code exactly
- If the spine says a constant is `0x01`, every branch doc must use `0x01` (not `1` or `0x1`)
- Terminology must be consistent — if the spine calls something "the escape prefix", all branch docs must too

---

## Step 6: Verify and Report

After regenerating, perform a consistency check:

1. **Protocol/API values**: Do all hex values and constant names match the source code?
2. **Version numbers**: Does the version in docs match `pyproject.toml` / `Cargo.toml` / etc.?
3. **Platform paths**: Are example paths correct for the claimed platform?
4. **Cross-links**: Do all relative links point to files that exist?
5. **Spine untouched**: Confirm no spine files were modified

Report results:

```
## Regen Complete

### Project detected:
- Type: [Python/Rust/C/etc.]
- Spine location: docs/spine/ (N files)
- Branch directories: docs/user/, docs/developer/, etc.

### Files written:
- docs/user/README.md (new/updated)
- docs/user/setup.md (new/updated)
... (list all)

### Spine files confirmed untouched:
- docs/spine/00-overview.md
... (list all)

### Changes from previous version:
- [what changed and why, or "First generation" if new]

### Consistency issues found:
- [any discrepancies, or "None found"]
```

---

## Special Cases

### If no spine directory exists
Report: "No spine directory found. The spine-first documentation pattern requires a `docs/spine/` (or `docs/source/`) directory containing authoritative reference documents. Please create this directory with your reference docs, then re-run `/regen-docs`."

Stop. Do not generate anything.

### If a branch directory has uncommitted local edits
Check `git status` before overwriting. If a branch file has local changes:
- Warn the user: "docs/user/setup.md has local uncommitted changes. Regenerating will overwrite them."
- Proceed anyway (the whole point is that branch files are generated, not hand-edited)

### If the project has no existing branch docs
Generate all branch directories based on the spine content. For a minimal project, create at minimum:
- `docs/user/` with `README.md` and `setup.md`
- `docs/developer/` with `README.md` and `api-reference.md` (if there's an API)

### If the spine documents a binary protocol
Branch docs for users should translate hex values to human descriptions ("the badge LED turns red").
Branch docs for developers should include all hex values in tables.
Branch docs for hackers/contributors should include the state machine and C/Rust/etc. implementation references.

---

## Adapting to Different Project Types

### Python library
Derive developer/api-reference.md from docstrings and type annotations. Include:
- All public functions with signatures, params, return types, exceptions
- All public classes with all public methods
- All public constants and enums
- Installation: `pip install package-name`
- Quick start code block

### CLI tool
Include a command reference table:
```
| Command | Arguments | Description |
|---------|-----------|-------------|
| dc29 teams | --port PORT | Run Teams bridge |
...
```

### Embedded firmware project
Include:
- Build system requirements (exact tool versions matter for embedded)
- Critical compiler flags / linker script settings (embedded projects have many footguns)
- Flash/program procedure
- Memory map
- Hardware pin assignments in a table

### REST API project
Include:
- Base URL and authentication
- Full endpoint table (method, path, parameters, response)
- Rate limiting and error codes
- `curl` examples for every endpoint
