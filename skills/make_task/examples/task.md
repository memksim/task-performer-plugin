---
id: "AUTH-001"
title: "Implement biometric authentication"
type: feature
priority: 1
assignee: senior-android-developer
depends_on: []
blocks: []
created_at: "2026-02-20T09:00:00Z"
updated_at: "2026-02-20T09:00:00Z"
status: "Ready for dev"
attempt: 0
---

# AUTH-001: Implement biometric authentication

## Problem Statement

Users have to enter password every time they open the app. This creates friction and reduces engagement.

## Task Description

Add biometric authentication (fingerprint/face) as an alternative to password login.

## Context

- Auth module: `feature/auth/`
- Security requirements in `docs/security.md`
- Design in Figma: Biometric Flow v2

## Constraints

- Use Android Biometric API
- Fallback to password if biometric fails
- Support API 23+
- Don't store biometric data

## Acceptance Criteria

- [ ] Fingerprint authentication works
- [ ] Face authentication works
- [ ] Fallback to password
- [ ] Proper error handling
- [ ] Unit tests

## Artifacts

- Source: `feature/auth/biometric/`
- Tests: `feature/auth/biometric/test/`

## Team Specification

| Role | Agent |
|------|-------|
| Developer | senior-android-developer |
| Reviewer | android-code-reviewer |
| QA | qa-expert |

## Status: Ready for dev
## Updated: 2026-02-20 09:00:00
