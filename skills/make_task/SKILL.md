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

## Task structure
1. Task identifier and title
2. Problem statement
3. Task description - what needs to be done
4. Constraints specification
5. Team specification - which subagents will be included in the work
6. Task status + time of its update (YYYY-MM-DD HH:mm:ss) 

