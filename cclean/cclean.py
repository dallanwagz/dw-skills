#!/usr/bin/env python3
"""Clean up Claude Code terminal output. Removes ❯ prompts and joins wrapped lines.

Usage:
  cclean              # reads clipboard, cleans, writes back to clipboard
  pbpaste | cclean    # pipe mode: reads stdin, writes stdout
"""
import sys
import re
import subprocess


def cleanup(text):
    text = re.sub(r'^❯\s*', '', text, flags=re.MULTILINE)
    lines = text.split('\n')
    paragraphs, current = [], []
    for line in lines:
        if line.strip() == '':
            if current:
                paragraphs.append(current)
                current = []
        else:
            current.append(line.strip())
    if current:
        paragraphs.append(current)
    return '\n\n'.join(re.sub(r'  +', ' ', ' '.join(p)) for p in paragraphs)


if sys.stdin.isatty():
    raw = subprocess.run(['pbpaste'], capture_output=True, text=True).stdout
    if not raw.strip():
        print('cclean: clipboard is empty', file=sys.stderr)
        sys.exit(1)
    cleaned = cleanup(raw)
    subprocess.run(['pbcopy'], input=cleaned, text=True)
    print(cleaned)
    print('\n✓ Cleaned — clipboard ready to paste', file=sys.stderr)
else:
    print(cleanup(sys.stdin.read()))
