
class BloodPressureLog {
  final String id;
  final String userId;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime loggedAt;

  BloodPressureLog({
    required this.id,
    required this.userId,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.loggedAt,
  });

  // Since this is encrypted, the 'data' field in Appwrite will be a base64 string
  // and we handle encryption/decryption locally.
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory BloodPressureLog.fromMap(Map<String, dynamic> map) {
    return BloodPressureLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      systolic: map['systolic'] ?? 0,
      diastolic: map['diastolic'] ?? 0,
      pulse: map['pulse'] ?? 0,
      loggedAt: DateTime.parse(map['loggedAt']),
    );
  }
}
