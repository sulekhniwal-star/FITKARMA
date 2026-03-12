import 'package:hive/hive.dart';

part 'dosha_profile.g.dart';

@HiveType(typeId: 5)
class DoshaProfile extends HiveObject {
  @HiveField(0)
  final double vata; // Percentage 0-1

  @HiveField(1)
  final double pitta; // Percentage 0-1

  @HiveField(2)
  final double kapha; // Percentage 0-1

  @HiveField(3)
  final DateTime lastUpdated;

  DoshaProfile({
    required this.vata,
    required this.pitta,
    required this.kapha,
    required this.lastUpdated,
  });

  String get dominantDosha {
    if (vata >= pitta && vata >= kapha) return 'Vata';
    if (pitta >= vata && pitta >= kapha) return 'Pitta';
    return 'Kapha';
  }
}
