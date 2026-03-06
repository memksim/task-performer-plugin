---
name: list_tasks
description: List all tasks with optional filtering by status, priority, type, and dependencies.
user-invokable: true
---

> Important: be sure to use the `task_management` skill.

## Overview

The `list_tasks` skill shows all tasks in the project with optional filtering and sorting.

## Usage

```
/list_tasks [options]
```

### Options

| Option | Format | Description |
|--------|--------|-------------|
| status | `status=ready_for_dev` | Filter by status (see valid values below) |
| priority | `priority=1,2` | Filter by priority (comma-separated) |
| type | `type=feature,bug` | Filter by type (comma-separated) |
| blocked | `blocked=true` | Show only blocked tasks |
| blocking | `blocking=true` | Show tasks that block others |
| depends_on | `depends_on=CORE-001` | Show tasks depending on specified task |
| format | `format=table\|json\|short` | Output format (default: table) |

### Status Values

- `ready_for_dev`
- `dev_in_progress`
- `ready_for_review`
- `review_in_progress`
- `changes_requested`
- `ready_for_qa_review`
- `qa_review_in_progress`
- `bugs_found`
- `verified`
- `blocked`

## Output Formats

### Table Format (default)

```
┌────────────┬─────────────────────────────┬──────────┬──────────────┬────────────┐
│ ID         │ Title                       │ Priority │ Status       │ Depends On │
├────────────┼─────────────────────────────┼──────────┼──────────────┼────────────┤
│ CORE-003   │ Phase 3 - Advanced features │ P2       │ Ready        │ CORE-001   │
│ CORE-001   │ Phase 1 - Basics            │ P2       │ In Progress  │ -          │
│ CORE-002   │ Phase 2 - Improvements      │ P2       │ Ready        │ CORE-001   │
│ CORE-004   │ Phase 4 - Optional features │ P3       │ Ready        │ CORE-003   │
└────────────┴─────────────────────────────┴──────────┴──────────────┴────────────┘
```

### Short Format

```
CORE-001 [P2] Dev in progress - Phase 1 - Basics
CORE-002 [P2] Ready for dev - Phase 2 - Improvements
CORE-003 [P2] Ready for dev - Phase 3 - Advanced features
CORE-004 [P3] Ready for dev - Phase 4 - Optional features
```

### JSON Format

```json
{
  "tasks": [
    {
      "id": "CORE-001",
      "title": "Phase 1 - Basics",
      "type": "feature",
      "priority": 2,
      "status": "Dev in progress",
      "depends_on": [],
      "blocks": ["CORE-002", "CORE-003"]
    }
  ],
  "total": 4,
  "filtered": 4
}
```

## Implementation

When listing tasks:

1. Scan `.claude/tasks/` directory for all task directories
2. For each directory, read `task.md` file
3. Parse YAML frontmatter if present, otherwise use legacy parsing
4. Apply filters if specified
5. Sort by priority (ascending), then by status (ready first), then by ID
6. Format and display output

### Parsing Task Files

**With YAML frontmatter:**
```
Parse the YAML block between --- markers
Extract all fields directly
```

**Legacy format (no frontmatter):**
```
ID: Extract from heading (# TASK-ID:)
Title: Extract from heading after ID
Status: Extract from "## Status:" line
Priority: Default to 2
Type: Default to "feature"
depends_on: Default to []
blocks: Default to []
```

### Sorting Order

1. Priority (1 = Critical first)
2. Status order:
   - Blocked
   - Ready for dev
   - Dev in progress
   - Changes requested
   - Bugs found
   - Ready for review
   - Review in progress
   - Ready for QA review
   - QA review in progress
   - Verified
3. ID alphabetically

## Examples

### List all tasks
```
/list_tasks
```

### List only ready tasks with high priority
```
/list_tasks status=ready_for_dev priority=1,2
```

### List blocked tasks
```
/list_tasks blocked=true
```

### List tasks blocking others
```
/list_tasks blocking=true
```

### Show tasks that depend on CORE-001
```
/list_tasks depends_on=CORE-001
```

### Output as JSON for scripting
```
/list_tasks format=json
```

## Summary View

After listing, show a summary:

```
Summary: 4 tasks total
  Ready for dev: 2
  Dev in progress: 1
  Blocked: 0
  Verified: 1

Priority breakdown:
  P1 (Critical): 0
  P2 (High): 3
  P3 (Medium): 1
  P4 (Low): 0
```
