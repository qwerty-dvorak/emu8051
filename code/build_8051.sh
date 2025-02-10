#!/bin/bash

# Function to print debug messages
log() {
  if [ "$DEBUG" = true ]; then
    echo "$@"
  fi
}

# Initialize DEBUG to false
DEBUG=false

# Parse arguments
while getopts ":d" opt; do
  case ${opt} in
    d )
      DEBUG=true
      ;;
    \? )
      echo "Usage: $0 [-d] <source_file.s>"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check if source file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 [-d] <source_file.s>"
  exit 1
fi

# Input source file
SOURCE_FILE="$1"
REL_FILE="${SOURCE_FILE%.s}.rel"
IHX_FILE="${SOURCE_FILE%.s}.ihx"
HEX_FILE="${SOURCE_FILE%.s}.hex"

# Assemble
log "Assembling $SOURCE_FILE..."
if ! sdas8051 -o "$REL_FILE" "$SOURCE_FILE" >/dev/null 2>&1; then
  echo "Build failed."
  exit 1
fi

# Link
log "Linking $REL_FILE..."
sdcc "$REL_FILE" >/dev/null 2>&1; 

# Check if IHX file was created
if [ ! -f "$IHX_FILE" ]; then
  echo "Build failed."
  exit 1
fi

# Convert to HEX
log "Converting $IHX_FILE to $HEX_FILE..."
if ! packihx "$IHX_FILE" > "$HEX_FILE" 2>/dev/null; then
  echo "Build failed."
  exit 1
fi

# Verify HEX file creation
if [ -f "$HEX_FILE" ]; then
  echo "Build successful! HEX file: $HEX_FILE"
else
  echo "Build failed."
  exit 1
fi
