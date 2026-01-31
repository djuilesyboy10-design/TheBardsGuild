#!/bin/bash
# Simple text replacement script for OpenMW mod development
# Usage: ./replace_text.sh <file> <search> <replace>

if [ $# -ne 3 ]; then
    echo "Usage: $0 <file> <search> <replace>"
    exit 1
fi

FILE="$1"
SEARCH="$2"
REPLACE="$3"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

# Create backup
cp "$FILE" "$FILE.backup"

# Perform replacement
sed -i "s|$SEARCH|$REPLACE|g" "$FILE"

echo "Replaced text in $FILE"
echo "Backup created: $FILE.backup"
