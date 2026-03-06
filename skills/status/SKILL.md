---
name: status
description: Show current project status dashboard with task counts, active work, and blocked items.
user-invokable: true
---

> Important: be sure to use the `task_management` skill first.

## Overview

The `status` skill shows a comprehensive dashboard of the current project state, including task counts, active work, blocked items, and recent activity.

## Usage

```
/status [options]
```

### Options

| Option | Format | Description |
|--------|--------|-------------|
| detailed | `detailed=true` | Show detailed breakdown with task IDs |
| team | `team=true` | Show team workload distribution |

## Output

### Standard Dashboard

```
╔═══════════════════════════════════════════════════════════════════╗
║                    PROJECT STATUS                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  TASKS OVERVIEW                                                   ║
║  Total: 12                                                        ║
║  Verified: 5 │ In Progress: 2 │ Ready: 4 │ Blocked: 1             ║
╠═══════════════════════════════════════════════════════════════════╣
║  PRIORITY BREAKDOWN                                               ║
║  P1 (Critical): 1 │ P2 (High): 4 │ P3 (Medium): 5 │ P4 (Low): 2   ║
╠═══════════════════════════════════════════════════════════════════╣
║  ACTIVE NOW                                                       ║
║  CORE-001 [Dev] senior-android-developer                          ║
║  Started: 10:30, Elapsed: 1h 20m                                  ║
║  ───────────────────────────────────────────────────────────────  ║
║  MUSIC-007 [QA] qa-expert                                         ║
║  Started: 11:00, Elapsed: 45m                                     ║
╠═══════════════════════════════════════════════════════════════════╣
║  BLOCKED                                                          ║
║  FEED-003: Waiting for CORE-001 to complete                       ║
╠═══════════════════════════════════════════════════════════════════╣
║  NEEDS ATTENTION                                                  ║
║  - CORE-002: Changes requested (review feedback pending)          ║
║  - MUSIC-005: Bugs found (awaiting fixes)                         ║
╠═══════════════════════════════════════════════════════════════════╣
║  UPCOMING (Ready for dev)                                         ║
║  P1: (none)                                                       ║
║  P2: CORE-003, CORE-004                                           ║
║  P3: FEED-002                                                     ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Detailed Dashboard (detailed=true)

```
╔═══════════════════════════════════════════════════════════════════╗
║                    PROJECT STATUS (DETAILED)                       ║
╠═══════════════════════════════════════════════════════════════════╣
║  BY STATUS                                                        ║
║  Ready for dev:        CORE-003, CORE-004, FEED-002               ║
║  Dev in progress:      CORE-001                                   ║
║  Changes requested:    CORE-002                                   ║
║  Ready for review:     (none)                                     ║
║  Review in progress:   (none)                                     ║
║  Ready for QA review:  MUSIC-006                                  ║
║  QA review in progress: MUSIC-007                                 ║
║  Bugs found:           MUSIC-005                                  ║
║  Verified:             CORE-000, FEED-001, MUSIC-001-004          ║
║  Blocked:              FEED-003                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║  BY ASSIGNEE                                                      ║
║  senior-android-developer: 3 tasks (2 active, 1 rework)           ║
║  android-code-reviewer: 0 tasks                                   ║
║  qa-expert: 2 tasks (1 active, 1 pending)                         ║
║  Unassigned: 4 tasks (ready for dev)                              ║
╠═══════════════════════════════════════════════════════════════════╣
║  BLOCKED TASKS                                                    ║
║  FEED-003 [Blocked] - Waiting for CORE-001 to complete            ║
║    Blockers: CORE-001 (Dev in progress)                           ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Team Dashboard (team=true)

```
╔═══════════════════════════════════════════════════════════════════╗
║                    TEAM WORKLOAD                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║  senior-android-developer                                         ║
║  Active: CORE-001 [Dev in progress]                               ║
║  Rework: CORE-002 [Changes requested]                             ║
║  Completed: 5 tasks                                               ║
╠═══════════════════════════════════════════════════════════════════╣
║  android-code-reviewer                                            ║
║  Active: (none)                                                   ║
║  Pending review: MUSIC-006                                        ║
║  Completed: 4 tasks                                               ║
╠═══════════════════════════════════════════════════════════════════╣
║  qa-expert                                                        ║
║  Active: MUSIC-007 [QA review in progress]                        ║
║  Pending QA: (none)                                               ║
║  Completed: 3 tasks                                               ║
╚═══════════════════════════════════════════════════════════════════╝
```

## Implementation

When generating status dashboard:

1. **Scan all tasks**: Read all task directories
2. **Parse metadata**: Extract status, priority, assignee, timestamps
3. **Calculate metrics**:
   - Count by status
   - Count by priority
   - Count by assignee
4. **Identify active work**: Tasks in progress with elapsed time
5. **Identify blocked**: Tasks with `Blocked` status
6. **Identify needs attention**: Tasks with `Changes requested` or `Bugs found`
7. **Format output**: Display dashboard

### Time Calculations

For active tasks, calculate elapsed time:
```
elapsed = current_time - updated_at (when status changed to in-progress)
```

Format as human-readable:
- `< 1h`: "Xm"
- `1-24h`: "Xh Ym"
- `> 24h`: "Xd Xh"

### Status Categories

| Category | Statuses |
|----------|----------|
| Verified | Verified |
| In Progress | Dev in progress, Review in progress, QA review in progress |
| Ready | Ready for dev, Ready for review, Ready for QA review |
| Rework | Changes requested, Bugs found |
| Blocked | Blocked |

## Examples

### Show project status
```
/status
```

### Show detailed status
```
/status detailed=true
```

### Show team workload
```
/status team=true
```

## Difference from list_tasks

- `list_tasks`: Lists tasks with filtering, focused on finding specific tasks
- `status`: High-level project overview, focused on understanding project health
