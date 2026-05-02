# analyze-notebook-outputs

Exports a Databricks notebook with cell outputs, analyzes the text/HTML output values, updates all markdown cells to match the actual output data, and re-imports the notebook — preserving all code cell output renders in the process.

## When to invoke

When the user says "analyze notebook outputs", "update notebook commentary", "refresh notebook markdown", or similar.

## How it works

The key insight: Databricks notebooks exported in **JUPYTER format** embed all cell outputs (HTML tables, stdout text, chart metadata) in the `.ipynb` JSON. Modifying only the `markdown` cells in that JSON and re-importing with `--format JUPYTER` preserves all code cell outputs in the workspace exactly as rendered.

## Parameters to collect

Ask the user for:
- **Workspace notebook path** (e.g., `/Users/dalwagne@adobe.com/Vuln Mgmt/my_notebook`)
- **Databricks profile** (e.g., `adobe-caspian-prod`)
- **Local temp path** (default: `/tmp/<notebook_name>_outputs.ipynb`)

## Step-by-step workflow

### 1. Export with outputs

```bash
databricks workspace export "<NOTEBOOK_PATH>" \
  --format JUPYTER \
  --file /tmp/<name>_outputs.ipynb \
  --profile <PROFILE>
```

### 2. Inspect cell structure

Map every cell: its index, type (code/markdown), and what outputs it has.

```python
import json
with open('/tmp/<name>_outputs.ipynb') as f:
    nb = json.load(f)

for i, cell in enumerate(nb['cells']):
    outputs = cell.get('outputs', [])
    src = ''.join(cell['source'])[:60].replace('\n',' ')
    out_types = []
    for o in outputs:
        if o.get('output_type') == 'stream':
            out_types.append(f'stdout({len(o.get("text",[]))} lines)')
        elif o.get('output_type') in ('display_data', 'execute_result'):
            keys = list(o.get('data', {}).keys())
            out_types.append('display:' + ','.join(keys))
    out_str = ' | '.join(out_types) if out_types else ''
    print(f'[{i:03d}] {cell["cell_type"]:8s} | {out_str:<50} | {src}')
```

Print this map to the user so they can see which cells produce what before any changes are made.

### 3. Extract text/HTML output values

For all cells with `stream`, `display_data`, or `execute_result` outputs:

```python
import re

for i, cell in enumerate(nb['cells']):
    for o in cell.get('outputs', []):
        otype = o.get('output_type')
        if otype == 'stream':
            text = ''.join(o.get('text', []))
            print(f'[{i}] STDOUT:\n{text[:600]}')
        elif otype in ('display_data', 'execute_result'):
            data = o.get('data', {})
            if 'text/html' in data:
                html = ''.join(data['text/html'])
                plain = re.sub(r'<[^>]+>', ' ', html)
                plain = re.sub(r' +', ' ', plain).strip()
                print(f'[{i}] HTML TABLE:\n{plain[:500]}')
            if 'text/plain' in data:
                print(f'[{i}] TEXT: {"".join(data["text/plain"])[:200]}')
            if 'image/png' in data:
                print(f'[{i}] [PNG — values not auto-extractable; leave commentary approximate or ask user]')
```

Read the extracted output, understand what each code cell is computing, then identify which adjacent markdown cells have stale commentary.

### 4. Update markdown cells

Modify only `cell_type == 'markdown'` cells. Never touch `cell_type == 'code'` cells or their outputs.

```python
def patch(cells, idx, replacements):
    cell = cells[idx]
    src = ''.join(cell['source'])
    for old, new in replacements:
        if old in src:
            src = src.replace(old, new)
        else:
            print(f'WARNING [{idx}]: not found: {repr(old[:50])}')
    cell['source'] = [src]
```

Apply targeted `(old, new)` string replacements — don't rewrite entire cells unless necessary. This makes the diff reviewable and minimizes risk.

### 5. Add a Run Summary cell

Insert a new markdown cell at position 1 (after the notebook title) that captures the key metrics from this run:

```python
summary_cell = {
    "cell_type": "markdown",
    "id": "run-summary-auto",
    "metadata": {},
    "source": [
        "---\n",
        "## Run Summary — Current Data Snapshot\n",
        "\n",
        "> *Auto-generated from cell output values. Re-run all cells then use `/analyze-notebook-outputs` to refresh.*\n",
        "\n",
        "| Metric | Value |\n",
        "|---|---|\n",
        # one row per key metric extracted from outputs
    ]
}
nb['cells'].insert(1, summary_cell)
```

Populate the table rows from the values you extracted in step 3. Keep only the most meaningful summary numbers — counts, rates, and key findings. Not every output value belongs here.

### 6. Save and re-import

```python
with open('/tmp/<name>_updated.ipynb', 'w') as f:
    json.dump(nb, f, indent=1)
```

```bash
databricks workspace import "<NOTEBOOK_PATH>" \
  --file /tmp/<name>_updated.ipynb \
  --format JUPYTER \
  --overwrite \
  --profile <PROFILE>
```

The `--format JUPYTER` flag on import is what preserves code cell outputs. The workspace notebook will show all charts and table renders exactly as they were, with updated markdown commentary alongside them.

## What to update vs. leave alone

| Output type | Action |
|---|---|
| `stdout` text / `text/html` tables | Extract exact values, update markdown precisely |
| `image/png` charts | Can't extract values — keep existing commentary or mark values as `(~X%, from chart)` |
| Counts, totals, key metrics | Always update when found in stdout/HTML |
| Percentages/ratios from text outputs | Update precisely |
| Percentages visible only in chart panels | Carry forward as approximate |
