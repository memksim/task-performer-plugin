---
id: "MUSIC-009"
title: "Add progress indicator around track cover"
type: feature
priority: 2
assignee: senior-android-developer
depends_on: []
blocks: []
created_at: "2026-01-12T12:15:00Z"
updated_at: "2026-01-12T12:15:00Z"
status: "Ready for dev"
attempt: 0
---

# MUSIC-009: Add progress indicator around track cover

## Problem Statement

Currently the user doesn't understand how much time remains until the end of the track.

## Task Description

Implement a circular progress bar around the album cover. Progress should update every second.

## Context

- Player screen: `feature/player/`
- Current cover component: `TrackCover.kt`

## Constraints

- Use Jetpack Compose
- No third-party libraries
- Don't degrade performance

## Acceptance Criteria

- [ ] Circular progress bar around cover
- [ ] Updates every second
- [ ] Smooth animation
- [ ] Works on low-end devices

## Artifacts

- Source: `feature/player/components/TrackProgressCover.kt`

## Team Specification

| Role | Agent |
|------|-------|
| Developer | senior-android-developer |
| Reviewer | android-code-reviewer |
| QA | qa-expert |

## Status: Ready for dev
## Updated: 2026-01-12 12:15:00
