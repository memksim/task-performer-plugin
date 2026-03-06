---
name: task_info
description: Show detailed information about a specific task including all metadata, history, and artifacts.
user-invokable: true
---

> Important: be sure to use the `task_management` skill first.

## Overview

The `task_info` skill displays complete information about a specific task, including all metadata, description, history, and links to artifacts.

## Usage

```
/task_info <TASK-ID>
```

### Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| TASK-ID | Yes | Task identifier (e.g., CORE-001, MUSIC-009) |

## Output

The skill outputs a comprehensive task card:

```
╔═══════════════════════════════════════════════════════════════════╗
║  TASK: CORE-001                                                   ║
║  Phase 1 - Basics of task system                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  Type: feature          Priority: P2 (High)        Status: Review ║
║  Assignee: senior-android-developer                               ║
╠═══════════════════════════════════════════════════════════════════╣
║  TIMELINE                                                         ║
║  Created:  2026-03-05 10:00:00                                    ║
║  Updated:  2026-03-05 11:00:00                                    ║
║  Attempt:  0                                                      ║
╠═══════════════════════════════════════════════════════════════════╣
║  DEPENDENCIES                                                     ║
║  Depends on: (none)                                               ║
║  Blocks:     CORE-002, CORE-003, CORE-004                         ║
╠═══════════════════════════════════════════════════════════════════╣
║  ACCEPTANCE CRITERIA                                              ║
║  [x] Extended task.md format documented                           ║
║  [x] BLOCKED status added                                         ║
║  [x] depends_on/blocks mechanism documented                       ║
║  [ ] list_tasks skill created                                     ║
╠═══════════════════════════════════════════════════════════════════╣
║  ARTIFACTS                                                        ║
║  - Updated: /skills/task_management/SKILL.md                      ║
║  - Created: /skills/list_tasks/SKILL.md                           ║
╠═══════════════════════════════════════════════════════════════════╣
║  HISTORY (last 5 entries)                                         ║
║  2026-03-05 10:00 | Ready for dev     | Task created              ║
║  2026-03-05 10:30 | Dev in progress   | Started development       ║
║  2026-03-05 11:00 | Ready for review  | Implementation complete   ║
╠═══════════════════════════════════════════════════════════════════╣
║  RELATED FILES                                                    ║
║  - dev_result.md                                                  ║
║  - code_review_result.md (pending)                                ║
╚═══════════════════════════════════════════════════════════════════╝
```

## Implementation

When showing task info:

1. **Read task file**: Read `.claude/tasks/<TASK-ID>/task.md`
2. **Parse metadata**: Extract YAML frontmatter
3. **Check history**: Read `task_history.md` if exists
4. **Check artifacts**: List all files in task directory
5. **Format output**: Display comprehensive card

### Priority Display

| Priority | Display | Badge |
|----------|---------|-------|
| 1 | P1 (Critical) | 🔴 |
| 2 | P2 (High) | 🟠 |
| 3 | P3 (Medium) | 🟡 |
| 4 | P4 (Low) | 🟢 |

### Status Display

| Status | Display | Color |
|--------|---------|-------|
| Ready for dev | Ready | ⚪ |
| Dev in progress | In Progress | 🔵 |
| Ready for review | Review | 🟣 |
| Review in progress | Reviewing | 🟣 |
| Changes requested | Rework | 🟠 |
| Ready for QA review | QA Ready | 🟡 |
| QA review in progress | QA | 🟡 |
| Bugs found | Bugs | 🔴 |
| Verified | Verified | 🟢 |
| Blocked | Blocked | 🔴 |

## Error Handling

### Task Not Found

If the specified task ID doesn't exist:
```
Error: Task 'CORE-999' not found.
Available tasks: CORE-001, CORE-002, CORE-003
```

### Invalid Task ID

If the task ID format is invalid:
```
Error: Invalid task ID 'invalid'. Expected format: PROJECT-NNN (e.g., CORE-001)
```

## Examples

### Show task details
```
/task_info CORE-001
```

### Show task with history
```
/task_info MUSIC-009
```

## Difference from list_tasks

- `list_tasks`: Shows multiple tasks in compact format with filtering
- `task_info`: Shows single task with full details, history, and artifacts
