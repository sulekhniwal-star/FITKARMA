# Phase 02: Theming & Brand Identity - Validation

## 1. Automated Verification
### Theme State (Unit Tests)
- [ ] Verify `DoshaThemeNotifier` initializes with the correct default.
- [ ] Verify calling `setDosha` updates the state and persists if configured.

### Color Mapping
- [ ] Verify each `DoshaType` maps to the intended `ColorScheme` primary/secondary colors.

## 2. Visual Verification (Manual - Golden Testing)
- [ ] **Vata Mode**: Verify the palette feels "Grounded" (Earthy tones).
- [ ] **Pitta Mode**: Verify the palette feels "Cooling" (Blues/Mints).
- [ ] **Kapha Mode**: Verify the palette feels "Energizing" (Yellows/Corals).
- [ ] **Glassmorphism**: Check for edge "leaks" and ensure blur doesn't disappear on transition.

## 3. Performance Benchmarks
- [ ] **FPS Check**: Navigate between screens with at least 5 `FKGlassCard` components; ensure 60fps on average devices.
- [ ] **Font Rendering**: Verify Noto Sans Devanagari renders correctly for Hindi characters.

## 4. Verification Map
| Task ID | Verification Step | Mode |
|---------|-------------------|------|
| 02-01-* | Pub get successful | Auto |
| 02-02-* | Theme switcher works in UI | Manual |
| 02-03-* | Glass Card opacity and blur check | Visual |
