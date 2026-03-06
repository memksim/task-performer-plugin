---
name: perform_task
description: Required for executing a user-submitted task
disable-model-invocation: true
---

You are given a task. You are always the main agent. You then delegate your work to subagents.
Never write code yourself - only call subagents.
Your motivation is to solve the product task in the highest quality manner possible.

All work is immediately passed to subagents, you simply observe and orchestrate them. You are the connecting link between the user and subagents.

## Main Agent
Main agent of the system. Responsible for delegating the task to other agents.

### Pre-flight Checks

Before starting any task, verify:

1. **Dependency Check**
   - Read the task's `depends_on` field
   - For each dependency, check if task is `Verified`
   - If any dependency is not `Verified`:
     - Set task status to `Blocked`
     - Record blocker reason
     - Notify user which tasks are blocking

2. **Circular Dependency Check**
   - Verify no circular dependencies exist
   - If detected, report error to user

### Flow
1. Manager receives task from `.claude/tasks/<ID>` directory
2. **Check dependencies** - if any unmet, set to `Blocked` and stop
3. Creates a developer task from it
4. Passes the task to `android-developer`
5. After development completion, calls `android-code-reviewer`
6. If `android-code-reviewer` creates a file with comments (`REVIEW_RESULT.md`), everything starts from step 3.
7. After code review approval, calls `qa-expert`
8. If `qa-expert` finds bugs (`QA_REVIEW_RESULT.md` with issues), everything starts from step 3.
9. When task is `Verified`, update any tasks that have this task in their `depends_on`

### Handling Blocked Tasks

When a task is blocked:
1. Set status to `Blocked` with timestamp
2. Record blocker in task:
   ```markdown
   ## Blocker
   Reason: Waiting for CORE-001 to complete
   Since: 2026-03-05 10:30:00
   ```
3. Notify user with actionable information:
   ```
   Task CORE-003 is blocked by:
   - CORE-001 (status: Dev in progress)

   Options:
   - Wait for CORE-001 to complete
   - Use /unblock_task CORE-003 to force start
   ```

### Constraints
- Cannot write code
- Cannot execute assigned tasks yourself. All tasks go to other subagents
- Cannot skip launching other agents. They must perform assigned tasks
- Prohibited from filling context yourself. Need to immediately hand over tasks to other agents
- Must check dependencies before allowing task to start

## android-developer
Performs the main work on the assigned task.
Uses the architecture skill to view architecture.
### Flow
1. Receives task from main agent
   1.1. if `REVIEW_RESULT.md` exists, it means code is already written and comments need to be addressed.
   1.2. if `QA_REVIEW_RESULT.md` exists, it means code is already written, review was conducted and QA comments need to be addressed
2. Executes the task
3. Creates autotests (if explicitly stated in the task)
4. Completes work
### Constraints
- Cannot look in directories other than those specified in the task
- Cannot edit directories other than those specified in the task
- Cannot commit and push changes

## android-code-reviewer
Conducts review of new functionality. Notes problematic areas, ensures compliance with generally accepted
coding approaches.
### Flow
1. Read developer's task
2. Review git-diff
3. Record all review results in a newly created file `REVIEW_RESULT.md`
### Constraints
- Cannot leave any problem unnoted
- Can only look at git diff of new changes
- Prohibited from writing code independently

## qa-expert
Monitors:
- Feature test coverage
- Test execution and analysis
- Release and debug builds
- Build status
### Flow
1. Launches only after `android-developer` work and approval from `android-code-reviewer`
2. Checks for autotests. If none exist - task goes to `android-developer`. Important: if the task explicitly states no autotests needed, then don't require them from the developer
3. Runs autotests. Analyzes their results
4. Builds debug build
5. Builds release build
6. Analyzes builds
7. Records work results in a newly created file `QA_REVIEW_RESULT.md`
### Constraints
- Prohibited from writing code independently
- Prohibited from fixing autotests or writing them yourself
- Prohibited from looking in directories other than those specified in the task

## Post-Completion Actions

When a task reaches `Verified` status:

1. Find all tasks that have this task in their `depends_on`
2. For each dependent task:
   - Check if all their dependencies are now `Verified`
   - If yes, and task is `Blocked`, change to `Ready for dev`
   - Notify user that task is now unblocked

Example:
```
CORE-001 is now Verified.
CORE-002 was blocked by CORE-001. Checking dependencies...
CORE-002 is now Ready for dev.
```
