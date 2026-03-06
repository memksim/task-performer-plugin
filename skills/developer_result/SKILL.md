---
name: developer_result
description: Information necessary for generating a report on completed development work
user-invokable: false
disable-model-invocation: true
---

## Purpose
Helps developers record the results of work on a task in the form of a clear report that:
- is easy for reviewers and QA to read
- clearly answers "what was done / where / how to verify"
- contains risks and technical debt
- is suitable for change history (release notes, postmortem)

## When to use
Use this skill:
- after completing development on a task (before moving to Ready for review / Ready for QA)
- after fixing bugs based on review/QA comments
- for any changes that could break builds, flows, analytics, networking, performance

## Input you must ask from user (only if missing)
If data is missing — ask without hesitation
If user provided enough information — don't ask questions.

## Output
Always generate/update file:
- `dev_result.md` (always next to task/in `<project_root>/.claude/tasks/<task_id>/dev_result.md`)
- if user explicitly specified a different path — use it

Style: strictly to the point, in English, no fluff.

## Rules
- Write specifics: module names, classes, methods, flags, keys, endpoints.
- Don't write "done/fixed" without clarifying **what exactly**.
- Always add a "How to verify" block with step-by-step actions.
- If there's a feature flag/toggle — specify name, default, where to enable.
- If APIs/contracts/schemas are affected — specify compatibility and migrations.
- If there are risks/debt — record honestly (but briefly) and suggest follow-up tasks.
- If many changes — group by subsystems/modules.
- Don't make things up. If you don't know — mark `TODO:` or ask 1 clarifying question.

## Template (fill-in)
Use this template as a base:

---
# Dev Result

## Task
- ID
- Context (1-2 sentences):

## Done
- [ ] (specific change #1)
- [ ] (specific change #2)
- [ ] …

## Where changed (code/modules)
- Modules:
- Main files/classes:
- Configs/manifest/gradle:

## Contracts and compatibility
- API/DTO/DB/protocols:
- Backward/forward compatibility:
- Migrations (if any):

## Feature flags / settings
- Flag:
  - name:
  - default:
  - where to enable:
  - impact:

## How to verify (manual testing)
1.
2.
3.
Expected result:
- …

## Tests
- Unit tests:
- Instrumental/screenshots:
- Manual checks/checklist:

## Logs/metrics/analytics
- Added/changed:
- Events (name, parameters):
- Where to look:

## Performance/memory (if relevant)
- What could be affected:
- What was checked:
- Results/numbers:

## Risks and limitations
- Risk:
- Conditions for occurrence:
- How to rollback/mitigate:

## Technical debt / follow-up
- [ ] Task:
- [ ] Task:

## Notes for reviewer / QA
- What to pay attention to:
- Non-standard solutions:
---

## Quality checklist (before finalizing)
Before final version check:
- Are there specific verification steps and expected results?
- Is it clear which files/modules were changed?
- Are toggles/settings specified?
- Are there honest risks/debt if they exist?
- Can "what exactly was done" be reconstructed from the text after 3 months?

## Additional Rules: Fixes After Review / QA
When to use
Use this mode if:
task returned from Review
task returned from QA
there were comments in PR/MR
there were bug reports for current task
### IMPORTANT: Don't rewrite history
When fixing comments:
DO NOT completely rewrite dev_result.md
DO NOT delete the "Done" block
DO NOT rewrite previous changes
Instead — add a separate section:
🛠 Fix Round
Each fix round should be a separate block:
```
## Fix Round #1 (after Review)
Date:
Basis: PR link/comment/QA-report link

### Fixed
- Was:
- Became:
- Where changed:

### Reason
Briefly: why it was initially done this way.

### Side effects
If affected:
- API
- behavior
- tests
- performance
If multiple fixes — add:
## Fix Round #2 (after QA)
🧠 Rules for describing fixes
Always show the difference "was → became".
Specify specific files/classes.
If tests added — specify which ones.
If comment rejected — record it:
### Not accepted
Comment:
Decision:
Rationale:
If fix could affect logic — update the "How to verify" block.
🔎 If fix is critical
If fix:
changes contract
changes DB schema
affects production data
affects performance
changes feature-flag
→ Add warning:
⚠️ Attention:
Change affects ...
🧩 Mini-checklist before closing fixes
Before final version agent must check:
Are all comments closed?
Are there updated verification steps?
Are tests added?
Is backward compatibility not broken?
Is it clear what exactly was fixed?
```