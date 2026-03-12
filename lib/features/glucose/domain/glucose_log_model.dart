/// Glucose reading types as per medical standards
enum GlucoseReadingType { fasting, postMeal1h, postMeal2h, random, bedtime }

/// Glucose classification per WHO/IDF standards
enum GlucoseClassification { normal, prediabetic, diabetic }

/// Glucose log model for tracking blood glucose levels
/// All fields are AES-256 encrypted before any Hive write or Appwrite sync
class GlucoseLog {
  final String id;
  final String userId;
  final double glucoseMgdl;
  final GlucoseReadingType readingType;
  final DateTime loggedAt;
  final GlucoseClassification classification;
  final String? notes;
  final String? foodLogId; // For post-meal correlation
  final String syncStatus;

  GlucoseLog({
    required this.id,
    required this.userId,
    required this.glucoseMgdl,
    required this.readingType,
    required this.loggedAt,
    required this.classification,
    this.notes,
    this.foodLogId,
    this.syncStatus = 'pending',
  });

  /// Classify fasting glucose level per WHO standards
  static GlucoseClassification classifyFasting(double mgdl) {
    if (mgdl >= 126) return GlucoseClassification.diabetic;
    if (mgdl >= 100) return GlucoseClassification.prediabetic;
    return GlucoseClassification.normal;
  }

  /// Classify post-meal (2-hour) glucose level per WHO standards
  static GlucoseClassification classifyPostMeal2h(double mgdl) {
    if (mgdl >= 200) return GlucoseClassification.diabetic;
    if (mgdl >= 140) return GlucoseClassification.prediabetic;
    return GlucoseClassification.normal;
  }

  /// Classify random glucose level per WHO standards
  static GlucoseClassification classifyRandom(double mgdl) {
    if (mgdl >= 200) return GlucoseClassification.diabetic;
    if (mgdl >= 140) return GlucoseClassification.prediabetic;
    return GlucoseClassification.normal;
  }

  /// Auto-classify based on reading type
  static GlucoseClassification classify(double mgdl, GlucoseReadingType type) {
    switch (type) {
      case GlucoseReadingType.fasting:
      case GlucoseReadingType.bedtime:
        return classifyFasting(mgdl);
      case GlucoseReadingType.postMeal1h:
      case GlucoseReadingType.postMeal2h:
        return classifyPostMeal2h(mgdl);
      case GlucoseReadingType.random:
        return classifyRandom(mgdl);
    }
  }

  /// Get target range string for display
  String get targetRange {
    switch (readingType) {
      case GlucoseReadingType.fasting:
        return '70-99 mg/dL';
      case GlucoseReadingType.postMeal1h:
        return '< 180 mg/dL';
      case GlucoseReadingType.postMeal2h:
        return '< 140 mg/dL';
      case GlucoseReadingType.random:
        return '< 140 mg/dL';
      case GlucoseReadingType.bedtime:
        return '100-130 mg/dL';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'glucoseMgdl': glucoseMgdl,
      'readingType': readingType.name,
      'loggedAt': loggedAt.toIso8601String(),
      'classification': classification.name,
      'notes': notes,
      'foodLogId': foodLogId,
      'syncStatus': syncStatus,
    };
  }

  factory GlucoseLog.fromMap(Map<String, dynamic> map) {
    return GlucoseLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      glucoseMgdl: (map['glucoseMgdl'] as num?)?.toDouble() ?? 0.0,
      readingType: GlucoseReadingType.values.firstWhere(
        (e) => e.name == map['readingType'],
        orElse: () => GlucoseReadingType.random,
      ),
      loggedAt: DateTime.parse(
        map['loggedAt'] ?? DateTime.now().toIso8601String(),
      ),
      classification: GlucoseClassification.values.firstWhere(
        (e) => e.name == map['classification'],
        orElse: () => GlucoseClassification.normal,
      ),
      notes: map['notes'],
      foodLogId: map['foodLogId'],
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  GlucoseLog copyWith({
    String? id,
    String? userId,
    double? glucoseMgdl,
    GlucoseReadingType? readingType,
    DateTime? loggedAt,
    GlucoseClassification? classification,
    String? notes,
    String? foodLogId,
    String? syncStatus,
  }) {
    return GlucoseLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      glucoseMgdl: glucoseMgdl ?? this.glucoseMgdl,
      readingType: readingType ?? this.readingType,
      loggedAt: loggedAt ?? this.loggedAt,
      classification: classification ?? this.classification,
      notes: notes ?? this.notes,
      foodLogId: foodLogId ?? this.foodLogId,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
