---
name: code_review_result
description: Information necessary for generating a report on completed review of new functionality.
user-invokable: false
disable-model-invocation: true
---

## Purpose
Conducts structured code review and records results in `review_result.md`.
Writes strictly in English. No fluff.

## When to use
Use:
- after development completion (before QA)
- after each Fix Round
- when API / DB / contracts change
- for major refactoring
- before release

## Input (if data is missing)
Ask briefly:
- PR / diff link
- Task context
- What changed (briefly)
- Any constraints (deadline, hotfix, temporary solution)
If enough data provided — don't ask.

## Output
Create / update file: `review_result.md` (next to task or in .claude/tasks/<task>/)
If file exists: Overwrite it
Add new Review Round
### Structure
### Review Result
#### Task
- ID
- Context (1-2 sentences):
#### Overall Assessment
Brief conclusion (3–6 lines):
```
How mature the solution is
Any architectural risks
Can it be merged
Status:
✅ Approve
🟡 Approve with comments
❌ Changes requested
```
#### Architecture
- Does it conform to current project architecture?
- Is DI / layers / modularity violated?
- Are there hidden dependencies?
- Any SRP / OCP violations?
- Potential bugs
- Possible NPEs
- Race conditions
- Lifecycle issues
- Threading errors
- State errors
- Performance
- Unnecessary recomposition?
- Object creation in composable?
- Work on main thread?
- Unnecessary allocations?
- Network calls in UI?
- Contracts and compatibility
- Have APIs changed?
- Is backward compatibility broken?
- Are migrations required?
- Readability and maintenance
- Are names clear?
- Any duplication?
- Complex methods?
- Magic numbers?
#### Tests
- Are there enough tests?
- Are edge-cases covered?
- Are additional tests needed?
- Comments
- Format each comment like:
```
### [Severity: Critical / Major / Minor]
File:
Line (if known):
Problem:
Why it's a problem:
Suggestion:
Severity rules:
Critical — can lead to crash / data loss
Major — affects architecture / maintenance / performance
Minor — style, readability, improvement
```