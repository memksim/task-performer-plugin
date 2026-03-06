---
name: make_task
description: Provides information necessary for creating a task or a set of tasks.
---

> Important: be sure to use the `task_management` skill.

## Task creation process
1. Receive request from user.
2. If user provided a research file, there's no need to call `research` independently.
3. Determine whether to describe everything in one task or split into a set of tasks
4. Create task identifier and task directory
5. Describe the task
6. Create a new subdirectory in the `.claude/tasks` directory (see section `How to determine which identifier to choose`)
7. Create a `task.md` file there, which will contain the full task description
8. If task has dependencies, update `depends_on` field and update dependent tasks' `blocks` field

> Important: if you created multiple tasks - for each one start from item 4 and continue to the end.

### How to determine how many tasks to create
1 task = minimum possible set of actions to achieve the desired goal.
First example:
```
User request: Fix CertificateCheckerImpl - Implement real SSL validation instead of a stub
> One task will be created
```
Second example:
```
User request: I have a set of issues. Need to do:
1) Add logout - Complete session and token cleanup
2) Add analytics - Track authorization success
3) Add tests - Unit and integration tests for all layers
4) State refactoring - Replace var state with StateFlow

> Accordingly, 4 tasks will be created.
```
Third example:
```
User request: Our project lacks certificate checks for webView, also I noticed tokens are not exchanged on 400 error.
Also it's strange that token expiration is not considered

> 3 tasks will be created:
- Add WebView certificate verification
- Implement token exchange for server-side errors
- Add token lifetime handling
```

### How to determine which identifier to choose
The user must always explicitly provide an identifier
Example:
```
1) Create task PMM-12346 [Large task description]
2) Create tasks based on research files(provided by user). Start with GAMES-001 and continue incrementally
```
If the user didn't provide a task ID - ask for it. Don't make it up yourself.

### Automatic ID Generation (Optional)

If user requests automatic ID generation, use this pattern:
1. Scan `.claude/tasks/` directory for existing task IDs
2. Find the highest number for the requested prefix
3. Generate next ID: `PREFIX-XXX` (zero-padded to 3 digits)

Example:
```
Existing: CORE-001, CORE-002, CORE-005
User wants: CORE prefix
Generated: CORE-006
```

## Task structure

### YAML Frontmatter (Required)

```yaml
---
id: "TASK-001"
title: "Short task title"
type: feature              # feature | bug | refactor | research | docs
priority: 2                # 1-4
assignee: senior-android-developer
depends_on: []             # List of blocking task IDs
blocks: []                 # List of blocked task IDs
created_at: "2026-03-05T10:00:00Z"
updated_at: "2026-03-05T10:00:00Z"
status: "Ready for dev"
attempt: 0
---
```

### Field Guidelines

| Field | How to determine |
|-------|------------------|
| id | User must provide, or auto-generate with prefix |
| title | Extract from user request, keep concise |
| type | Infer from request: new functionality=feature, fix=bug, etc. |
| priority | Default to 2 (High) unless user specifies |
| assignee | Default to `senior-android-developer` |
| depends_on | Empty by default, add if task clearly depends on another |
| blocks | Empty by default, will be populated automatically |
| created_at | Current timestamp in ISO 8601 |
| updated_at | Same as created_at initially |
| status | Always start with `Ready for dev` |
| attempt | Always start with 0 |

### Markdown Content (Required)

1. **Task identifier and title** - Heading with ID and title
2. **Problem statement** - What problem needs to be solved
3. **Task description** - What needs to be done
4. **Context** - Links, files, design references (if available)
5. **Constraints** - Limitations and requirements
6. **Acceptance Criteria** - Checklist of completion criteria
7. **Artifacts** - Expected output files/paths
8. **Team specification** - Which subagents will work on this
9. **Task status** - Status with timestamp

## Task Template

```markdown
---
id: "{{ID}}"
title: "{{TITLE}}"
type: {{TYPE}}
priority: {{PRIORITY}}
assignee: senior-android-developer
depends_on: []
blocks: []
created_at: "{{TIMESTAMP}}"
updated_at: "{{TIMESTAMP}}"
status: "Ready for dev"
attempt: 0
---

# {{ID}}: {{TITLE}}

## Problem Statement

{{PROBLEM_DESCRIPTION}}

## Task Description

{{WHAT_NEEDS_TO_BE_DONE}}

## Context

{{CONTEXT_ITEMS}}

## Constraints

{{CONSTRAINTS}}

## Acceptance Criteria

- [ ] {{CRITERION_1}}
- [ ] {{CRITERION_2}}
- [ ] {{CRITERION_3}}

## Artifacts

{{EXPECTED_ARTIFACTS}}

## Team Specification

| Role | Agent |
|------|-------|
| Developer | senior-android-developer |
| Reviewer | android-code-reviewer |
| QA | qa-expert |

## Status: Ready for dev
## Updated: {{DATE}}
```

## Dependency Management

### When creating a task with dependencies

1. Add task IDs to `depends_on` field
2. For each dependency, update the dependent task's `blocks` field

Example:
```
Creating CORE-003 that depends on CORE-001 and CORE-002:

CORE-003/task.md:
  depends_on: ["CORE-001", "CORE-002"]

CORE-001/task.md:
  blocks: ["CORE-003"]  # Add if not present

CORE-002/task.md:
  blocks: ["CORE-003"]  # Add if not present
```

### Circular Dependency Check

Before finalizing dependencies, verify no circular dependencies exist:
1. For each task in `depends_on`, recursively check its dependencies
2. If current task ID appears in the chain, reject with error
3. Maximum recursion depth: 10 levels
