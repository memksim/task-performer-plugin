---
name: list_tasks
description: List all tasks with their YAML content.
user-invokable: true
---

## Overview

The `list_tasks` skill shows all tasks in the project with their YAML content. This is a simple bash script that directly reads task directories and displays their YAML frontmatter.

## Usage

```
./list_tasks.sh
```

Or if using Claude Code skills:
```
/list_tasks
```

## Output Format

The script outputs each task's YAML content in a simple, readable format:

```
=== CORE-001 ===
id: "CORE-001"
title: "Phase 1 - Basics of task system"
type: feature
priority: 2
assignee: senior-android-developer
depends_on: []
blocks: ["CORE-002", "CORE-003", "CORE-004"]
created_at: "2026-03-05T10:00:00Z"
updated_at: "2026-03-05T11:00:00Z"
status: "Ready for review"
attempt: 0

=== CORE-002 ===
id: "CORE-002"
title: "Phase 2 - Workflow improvements"
type: feature
priority: 2
assignee: senior-android-developer
depends_on: ["CORE-001"]
blocks: ["CORE-003", "CORE-004"]
created_at: "2026-03-05T10:00:00Z"
updated_at: "2026-03-06T12:00:00Z"
status: "Ready for review"
attempt: 0
```

## Implementation

This skill uses a simple bash script that directly reads files without agent overhead:

1. Scan project root `.claude/tasks/` directory for all task directories
2. For each directory, read `task.md` file
3. Extract and display the YAML frontmatter from each task file

The script is fast and efficient, providing raw YAML output for further processing.

### Script Location

The script is located at:
```
/skills/list_tasks/list_tasks.sh
```

To run directly:
```
bash /Users/m.kosenko/WebstormProjects/task-performer/skills/list_tasks/list_tasks.sh
```

## Examples

### List all tasks (simple output)
```
/list_tasks
```

## Notes

- This is a simple, fast alternative to agent-based task listing
- For advanced filtering and sorting, consider using the task_management skill
- The raw YAML output can be piped to other tools (jq, grep, etc.) for custom processing
- No agent overhead means instant results
