# Phase 2 Research: Shell & Dashboard UI

## Concentric Activity Rings with Icons
- **Implementation**: `CustomPainter` with 4 concentric paths.
- **Icons**: Icons (lightning, steps, water, clock) will be drawn using `TextPainter` or `Canvas.drawPath` at the center of each ring (at a specific degree, usually 0Â° or 180Â°).
- **Icons Location**: To be inside the ring path, they need to be scaled appropriately to fit the stroke width (~10px).

## Random Bilingual Greeting Generator
- **Structure**: A fixed map of English vs Hindi greetings.
- **Provider**: A Riverpod provider that picks a random entry on build/app start.
- **Examples**:
    - "Good Morning" / "सुप्रभात"
    - "Namaste" / "नमस्ते"
    - "Stay Hydrated" / "हाइड्रेटेड रहें"

## Dashboard State
- **Riverpod**: Create a `DashboardState` data class to hold calories, steps, water, active minutes.
- **Mocking**: Use a `StateProvider` or `Notifier` to provide initial dummy values for Phase 2 visualization.

## Dependencies to Add
No new dependencies are strictly required, but `flutter_svg` might be useful for icons if they aren't standard Material icons. However, for 100% adherence to "zero extra costs/complexity," standard Icons or CustomPainter draws are preferred.
