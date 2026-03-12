/// Body measurement model for tracking body metrics
class BodyMeasurement {
  final String id;
  final String userId;
  final DateTime date;
  final double? weightKg;
  final double? heightCm;
  final double? chestCm;
  final double? waistCm;
  final double? hipsCm;
  final double? armsCm;
  final double? thighsCm;
  final double? bodyFatPct;
  final String syncStatus;

  BodyMeasurement({
    required this.id,
    required this.userId,
    required this.date,
    this.weightKg,
    this.heightCm,
    this.chestCm,
    this.waistCm,
    this.hipsCm,
    this.armsCm,
    this.thighsCm,
    this.bodyFatPct,
    this.syncStatus = 'pending',
  });

  /// Calculate BMI (Body Mass Index)
  /// BMI = weight(kg) / height(m)^2
  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm == 0) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Calculate Waist-to-Hip Ratio (WHR)
  double? get waistToHipRatio {
    if (waistCm == null || hipsCm == null || hipsCm == 0) return null;
    return waistCm! / hipsCm!;
  }

  /// Calculate Waist-to-Height Ratio (WHtR)
  double? get waistToHeightRatio {
    if (waistCm == null || heightCm == null || heightCm == 0) return null;
    return waistCm! / heightCm!;
  }

  /// Check if measurements are complete for BMI calculation
  bool get hasBmiData => weightKg != null && heightCm != null;

  /// Check if measurements are complete for WHR calculation
  bool get hasWhrData => waistCm != null && hipsCm != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'weightKg': weightKg,
      'heightCm': heightCm,
      'chestCm': chestCm,
      'waistCm': waistCm,
      'hipsCm': hipsCm,
      'armsCm': armsCm,
      'thighsCm': thighsCm,
      'bodyFatPct': bodyFatPct,
      'syncStatus': syncStatus,
    };
  }

  factory BodyMeasurement.fromMap(Map<String, dynamic> map) {
    return BodyMeasurement(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      weightKg: map['weightKg']?.toDouble(),
      heightCm: map['heightCm']?.toDouble(),
      chestCm: map['chestCm']?.toDouble(),
      waistCm: map['waistCm']?.toDouble(),
      hipsCm: map['hipsCm']?.toDouble(),
      armsCm: map['armsCm']?.toDouble(),
      thighsCm: map['thighsCm']?.toDouble(),
      bodyFatPct: map['bodyFatPct']?.toDouble(),
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  BodyMeasurement copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weightKg,
    double? heightCm,
    double? chestCm,
    double? waistCm,
    double? hipsCm,
    double? armsCm,
    double? thighsCm,
    double? bodyFatPct,
    String? syncStatus,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      chestCm: chestCm ?? this.chestCm,
      waistCm: waistCm ?? this.waistCm,
      hipsCm: hipsCm ?? this.hipsCm,
      armsCm: armsCm ?? this.armsCm,
      thighsCm: thighsCm ?? this.thighsCm,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
