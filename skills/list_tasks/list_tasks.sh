#!/bin/bash

# Simple script to list all task directories and display their YAML content
# Usage: ./list_tasks.sh

TASKS_DIR="/Users/m.kosenko/WebstormProjects/task-performer/.claude/tasks"

# Check if tasks directory exists
if [ ! -d "$TASKS_DIR" ]; then
    echo "No tasks directory found at $TASKS_DIR"
    exit 1
fi

# Get all task directories
TASK_DIRS=$(find "$TASKS_DIR" -maxdepth 1 -type d -name "*" | grep -v "^${TASKS_DIR}$" | sort)

if [ -z "$TASK_DIRS" ]; then
    echo "No task directories found"
    exit 0
fi

# Process each task directory
for TASK_DIR in $TASK_DIRS; do
    TASK_ID=$(basename "$TASK_DIR")
    TASK_FILE="${TASK_DIR}/task.md"

    # Skip if task.md doesn't exist
    if [ ! -f "$TASK_FILE" ]; then
        continue
    fi

    echo "=== $TASK_ID ==="

    # Extract YAML frontmatter
    if grep -q "^---$" "$TASK_FILE" 2>/dev/null; then
        # Find the second '---' which ends the YAML block
        awk '
        /^---$/ {
            if (yaml_started == 0) {
                yaml_started = 1
                next
            } else {
                yaml_started = 0
                exit
            }
        }
        yaml_started == 1 {
            print
        }
        ' "$TASK_FILE"
    else
        echo "No YAML frontmatter found"
    fi

    echo ""
done
