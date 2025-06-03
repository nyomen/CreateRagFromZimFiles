#!/bin/bash

set -e

FOLDER="$1"

if [ -z "$FOLDER" ] || [ ! -d "$FOLDER" ]; then
    echo "Usage: $0 /path/to/folder"
    exit 1
fi

echo "🔍 Scanning all files to identify HTML documents..."

# Temp files
HTML_LIST=$(mktemp)
CLEANER_SCRIPT=$(mktemp --suffix=.py)
PROGRESS_FILE=$(mktemp)

TOTAL_FILES=$(find "$FOLDER" -type f | wc -l)
echo "Total files to scan: $TOTAL_FILES"

# Parallel MIME-type check for HTML files
find "$FOLDER" -type f -print0 | \
  pv -0 -s "$TOTAL_FILES" | \
  xargs -0 -P"$(nproc)" -n1 bash -c '
    for f; do
      if file -b "$f" | grep -q "HTML document"; then
        printf "%s\0" "$f"
      fi
    done
' _ > "$HTML_LIST"

matched=$(tr -cd '\0' < "$HTML_LIST" | wc -c)
echo "✅ Done scanning: $TOTAL_FILES files checked, $matched HTML files found."
echo 0 > "$PROGRESS_FILE"

# Cleaner script with progress
cat > "$CLEANER_SCRIPT" << 'EOF'
import sys
import os
from bs4 import BeautifulSoup
from readability import Document

file_path = sys.argv[1]
progress_file = sys.argv[2]
total_files = int(sys.argv[3])

try:
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        html = f.read()
    doc = Document(html)
    summary = doc.summary()
    soup = BeautifulSoup(summary, 'lxml')
    text = soup.get_text()
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(text.strip())
except Exception as e:
    print(f"❌ Error: {file_path}: {e}", file=sys.stderr)

# Progress tracking
try:
    with open(progress_file, 'r+') as pf:
        count = int(pf.read().strip())
        pf.seek(0)
        pf.write(str(count + 1))
        pf.truncate()

        percent = int((count + 1) / total_files * 100)
        if (count + 1) % max(1, total_files // 50) == 0:
            print(f"📈 Progress: {count + 1}/{total_files} ({percent}%)")
except:
    pass
EOF

echo "🚀 Cleaning $matched HTML files using $(nproc) threads..."

xargs -0 -P"$(nproc)" -I{} python3 "$CLEANER_SCRIPT" "{}" "$PROGRESS_FILE" "$matched" < "$HTML_LIST"

# Cleanup
rm "$CLEANER_SCRIPT" "$HTML_LIST" "$PROGRESS_FILE"

echo "🎉 All done!"
