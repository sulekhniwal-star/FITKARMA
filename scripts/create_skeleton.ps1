$dirs = @(
  'lib/core/config',
  'lib/core/theme',
  'lib/core/router',
  'lib/core/database',
  'lib/core/sync',
  'lib/core/security',
  'lib/core/providers',
  'lib/core/services',
  'lib/shared/widgets',
  'lib/features/onboarding',
  'lib/features/dashboard',
  'lib/features/food/data/models',
  'lib/features/food/presentation',
  'lib/features/workout',
  'lib/features/steps',
  'lib/features/health',
  'lib/features/karma',
  'lib/features/social',
  'lib/features/reports',
  'lib/features/festival',
  'lib/features/wedding',
  'lib/features/ai_coach',
  'lib/features/settings',
  'lib/features/insights',
  'assets/fonts',
  'assets/data',
  'functions/fitkarma-core/src/handlers',
  'scripts'
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Path "f:\fitkarma\$d" -Force | Out-Null
}

$placeholders = @(
  'lib/core/config/device_tier.dart',
  'lib/core/config/user_experience_stage.dart',
  'lib/core/theme/app_colors.dart',
  'lib/core/theme/app_spacing.dart',
  'lib/core/theme/app_typography.dart',
  'lib/core/theme/app_gradients.dart',
  'lib/core/theme/app_springs.dart',
  'lib/core/theme/app_theme.dart',
  'lib/core/router/app_router.dart',
  'lib/core/router/transitions.dart',
  'lib/core/database/app_database.dart',
  'lib/core/sync/sync_worker.dart',
  'lib/core/security/biometric_lock.dart',
  'lib/core/providers/core_providers.dart',
  'lib/core/providers/feature_flags_provider.dart',
  'lib/core/providers/low_data_mode_provider.dart',
  'lib/core/services/storage_service.dart',
  'lib/shared/widgets/bento_card.dart',
  'lib/shared/widgets/activity_rings.dart',
  'lib/shared/widgets/glowing_metric.dart',
  'lib/shared/widgets/insight_card.dart',
  'lib/shared/widgets/quick_log_fab.dart',
  'lib/shared/widgets/bilingual_label.dart',
  'lib/shared/widgets/encryption_badge.dart',
  'lib/shared/widgets/shimmer_loader.dart',
  'lib/shared/widgets/trend_chip.dart',
  'lib/shared/widgets/pulse_ring.dart',
  'lib/shared/widgets/streak_flame.dart',
  'lib/shared/widgets/bottom_nav_bar.dart',
  'lib/shared/widgets/empty_state.dart',
  'lib/shared/widgets/animation_widgets.dart',
  'lib/shared/widgets/level_up_animation.dart',
  'lib/shared/widgets/breathing_circle.dart',
  'lib/shared/widgets/sync_status_banner.dart',
  'lib/shared/widgets/logo_reveal.dart',
  'lib/shared/widgets/ambient_blobs.dart',
  'lib/features/onboarding/splash_screen.dart',
  'lib/features/onboarding/welcome_screen.dart',
  'lib/features/onboarding/auth_screen.dart',
  'lib/features/onboarding/dosha_quiz_screen.dart',
  'lib/features/onboarding/goals_screen.dart',
  'lib/features/onboarding/permissions_screen.dart',
  'lib/features/onboarding/onboarding_providers.dart',
  'lib/features/dashboard/dashboard_screen.dart',
  'lib/features/food/data/food_database_service.dart',
  'lib/features/food/data/open_food_facts_client.dart',
  'lib/features/food/data/models/food_item.dart',
  'lib/features/food/presentation/food_home_screen.dart',
  'lib/features/food/presentation/food_search_sheet.dart',
  'lib/features/workout/workout_screen.dart',
  'lib/features/steps/steps_screen.dart',
  'lib/features/health/blood_pressure_screen.dart',
  'lib/features/health/glucose_screen.dart',
  'lib/features/health/sleep_screen.dart',
  'lib/features/karma/karma_screen.dart',
  'lib/features/social/social_screen.dart',
  'lib/features/reports/lab_reports_screen.dart',
  'lib/features/festival/festival_screen.dart',
  'lib/features/wedding/wedding_screen.dart',
  'lib/features/ai_coach/ai_coach_screen.dart',
  'lib/features/settings/settings_screen.dart',
  'lib/features/insights/correlation_engine.dart'
)

foreach ($f in $placeholders) {
  $path = "f:\fitkarma\$f"
  if (-not (Test-Path $path)) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($f)
    "// TODO: Implement $name" | Out-File -FilePath $path -Encoding utf8
  }
}

# Asset placeholders
$jsonPath = "f:\fitkarma\assets\data\indian_foods_seed.json"
if (-not (Test-Path $jsonPath)) { '[]' | Out-File -FilePath $jsonPath -Encoding utf8 }
$keepPath = "f:\fitkarma\assets\fonts\.gitkeep"
if (-not (Test-Path $keepPath)) { '' | Out-File -FilePath $keepPath -Encoding utf8 }

Write-Host "Directory skeleton created successfully"
