---
phase: 01
slug: foundation-architecture
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-09
---

# Phase 01 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter test |
| **Config file** | pubspec.yaml |
| **Quick run command** | `flutter test --no-pub` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test --no-pub`
- **After every plan wave:** Run `flutter test`
- **Before /gsd:verify-work:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | CORE-01 | structural | `flutter analyze` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | CORE-01 | smoke | `flutter test test/app_test.dart` | ❌ W0 | ⬜ pending |
| 01-01-03 | 01 | 1 | CORE-01 | structural | `find packages/fitkarma_ui -name pubspec.yaml` | ❌ W0 | ⬜ pending |
| 01-01-04 | 01 | 1 | CORE-01 | smoke | `flutter pub get` | ✅ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `packages/fitkarma_ui/pubspec.yaml` — skeleton for design system package
- [ ] `test/app_test.dart` — basic smoke test for initialization
- [ ] `mason_cli` — globally activated for scaffold generation

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Project Structure | CORE-01 | Aesthetic check | Verify folders mapping to Feature-First pattern in VS Code explorer. |
| Mason Scaffold | CORE-01 | DevEx check | Run `mason make feat -n step_tracking` and verify correct folder generation. |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
