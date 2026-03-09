# Research Dimension: Pitfalls (2025)

## Critical Watchlist

| Pitfall | Warning Sign | Prevention Strategy | Phase |
|---------|--------------|---------------------|-------|
| **Medical OCR Errors** | Hallucinated values (e.g., Hb 1.2 instead of 12). | Add 300 DPI quality check before processing; Add mandatory user confirmation screen for extracted values. | Phase 3 |
| **Battery Drain** | High background activity for step tracking. | Use native pedometer APIs (Health Connect/HealthKit) instead of manual GPS polling for steps. | Phase 1 |
| **Sync Conflicts** | "Ghost" edits where local changes are overwritten by older server data. | Implement "Last-Write-Wins" using server timestamps + Client-side sequence numbers for action ordering. | Phase 1 |
| **Privacy Breach** | PHI (Protected Health Information) leaking to logs. | Disable logging in production for the Medical Report module; use Hive Box Encryption. | Phase 3 |
| **OFF Coverage Gaps** | Users can't find local Indian brand products. | Implement broad search and "Quick Add" for manual entry; contribute missing items back to OFF API. | Phase 2 |

## Domain-Specific Mistake: "The Western Trap"
Many Indian fitness apps fail by using standard BMI/TDEE calculations without adjusting for Indian phenotypes (which often have higher body fat % at lower BMIs). 

**Prevention**: Incorporate Indian-specific health benchmarks and Ayurvedic body-type considerations (Prakriti) into the core health scoring logic.

## Technical Mistake: "The Kill-Process Trap"
Relying on `Workmanager` for 100% reliable periodic sync.
**Prevention**: Always trigger a "Catch-up Sync" on App Resume/Startup in addition to background tasks.
