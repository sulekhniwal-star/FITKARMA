/// Medication category
enum MedicationCategory {
  prescription,
  otc, // Over-the-counter
  supplement,
  ayurvedic,
}

/// Medication reminder model
class Medication {
  final String id;
  final String userId;
  final String name;
  final String dosage; // e.g., "500mg"
  final Map<String, dynamic>
  frequency; // {"times": ["08:00", "20:00"], "days": "daily"}
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? refillDate;
  final bool isActive;
  final MedicationCategory category;
  final String? notes;
  final String syncStatus;

  Medication({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.refillDate,
    this.isActive = true,
    required this.category,
    this.notes,
    this.syncStatus = 'pending',
  });

  /// Get frequency display string
  String get frequencyDisplay {
    final days = frequency['days'] ?? 'daily';
    final times = (frequency['times'] as List<dynamic>?)?.cast<String>() ?? [];

    if (days == 'daily') {
      return times.isEmpty ? 'Daily' : 'Daily at ${times.join(', ')}';
    }
    return '$days at ${times.join(', ')}';
  }

  /// Get category label
  String get categoryLabel {
    switch (category) {
      case MedicationCategory.prescription:
        return 'Prescription';
      case MedicationCategory.otc:
        return 'Over-the-counter';
      case MedicationCategory.supplement:
        return 'Supplement';
      case MedicationCategory.ayurvedic:
        return 'Ayurvedic';
    }
  }

  /// Check if refill is needed soon (within 3 days)
  bool get refillNeeded {
    if (refillDate == null) return false;
    final daysUntilRefill = refillDate!.difference(DateTime.now()).inDays;
    return daysUntilRefill <= 3 && daysUntilRefill >= 0;
  }

  /// Check if medication has ended
  bool get hasEnded {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }

  /// Get next reminder time
  String? getNextReminderTime() {
    if (!isActive || hasEnded) return null;

    final times = (frequency['times'] as List<dynamic>?)?.cast<String>() ?? [];
    if (times.isEmpty) return null;

    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    for (final time in times) {
      if (time.compareTo(currentTime) > 0) {
        return time;
      }
    }

    // Next reminder is tomorrow
    return times.first;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'refillDate': refillDate?.toIso8601String(),
      'isActive': isActive,
      'category': category.name,
      'notes': notes,
      'syncStatus': syncStatus,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: (map['frequency'] is Map)
          ? Map<String, dynamic>.from(map['frequency'])
          : {'times': [], 'days': 'daily'},
      startDate: DateTime.parse(
        map['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      refillDate: map['refillDate'] != null
          ? DateTime.parse(map['refillDate'])
          : null,
      isActive: map['isActive'] ?? true,
      category: MedicationCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => MedicationCategory.prescription,
      ),
      notes: map['notes'],
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  Medication copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    Map<String, dynamic>? frequency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? refillDate,
    bool? isActive,
    MedicationCategory? category,
    String? notes,
    String? syncStatus,
  }) {
    return Medication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      refillDate: refillDate ?? this.refillDate,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
