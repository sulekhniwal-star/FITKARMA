# Phase 3 Research: Local Activity Tracking

## Data Models
We need Hive-compatible models for tracking various health metrics locally.

- **ActivityLog**: A generic model for steps and active minutes.
  - Fields: `id`, `date`, `steps`, `activeMinutes`, `isSynced`.
- **WaterLog**:
  - Fields: `id`, `date`, `amountGlasses`, `isSynced`.
- **WorkoutLog**:
  - Fields: `id`, `title`, `type`, `durationMinutes`, `caloriesBurned`, `timestamp`, `isSynced`.

## Hive Setup
We will need to register adapters for these models in `HiveService.init()`.
- TypeId assignments:
  - `SyncQueueItem`: 0 (done)
  - `ActivityLog`: 1
  - `WaterLog`: 2
  - `WorkoutLog`: 3

## Services & Repositories
- **ActivityRepository**: Interface for saving/get logs.
- **HiveActivityRepository**: Concrete implementation using Hive boxes.

## Integration with Dashboard
The `DashboardController` will be updated to watch these local boxes instead of using static mock data. It should aggregate day-totals from the logs.
