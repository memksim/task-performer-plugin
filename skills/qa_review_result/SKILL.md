---
name: qa_review_result
description: Gets information on how to record QA expert review results
user-invokable: false
---

## Purpose
Records the result of comprehensive QA verification of mobile functionality (iOS + Android).
Creates a structured report:
- Build status
- Autotests
- Coverage
- Security
- Accessibility
- Bugs
- Final quality score
- Decision (Verified / Blocked)
Writes strictly in English. No fluff.

## When to use
Use:
- after Review
- before moving task to Verified
- before release
- after fixing QA comments
- for critical features (auth, payment, session, storage)

## Output
Creates / updates: `qa_review_result.md`
If the file exists: overwrite it
### Structure
QA Review Result
- ID
- Context (1-2 sentences):
Platform: Android / iOS
#### Build Verification
- Status:
- Variant:
- Warnings:
❗ If build does not pass — status automatically Blocked.
#### Autotests
Total tests:
- Run:
- Passed:
- Failed:
- Flaky:
If there are failures:
```
### [Severity: Critical]
Test:
Reason:
Logs:
```
#### Test Coverage
- Overall:
- New code:
- Critical paths:
- Critical paths:
- If < 70% new code → Warning
- If < 60% → Block
- Uncovered areas:
- File:
- Method:
- Edge case:
#### Security Audit (IS)
Checked:
- Logs don't contain tokens / PII
- No hardcoded keys
- HTTPS enforced
- Certificate not disabled
- No insecure WebView
- No export of internal activities (Android)
- ATS check (iOS)
- If vulnerability found:
### [Severity: Critical / High / Medium]
File:
Description:
Risk:
Recommendation:
#### Accessibility (WCAG 2.1 AA)
```
Android (TalkBack)
Touch targets ≥ 48dp
Contrast ≥ 4.5:1
ContentDescription
Focus order
iOS (VoiceOver)
Labels
Hints
Touch targets ≥ 44pt
Dynamic Type support
If violated:
### [Severity: High / Medium]
Screen:
Problem:
Recommendation:
```
#### Bug Analysis
Checked:
null safety
lifecycle
memory leaks
race conditions
rotation / background
network error handling
Format bugs:
### [Severity: Critical / High / Medium / Low]
Platform:
File / screen:
Description:
How to reproduce:
Expected behavior:
Actual behavior:
### Final Assessment
```
Quality Score: XX / 100
Critical problems:
…
High:
…
Medium:
…
Low:
…
Final status
✅ Verified
🟡 Verified with minor issues
❌ Blocked
```
