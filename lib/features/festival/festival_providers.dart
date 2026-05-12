import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/core_providers.dart';

part 'festival_providers.g.dart';

class FestivalItem {
  final String id;
  final String englishName;
  final String hindiName;
  final DateTime date;
  final String nutritionTips;
  final String specialFoods;
  final String activityRecommendations;

  FestivalItem({
    required this.id,
    required this.englishName,
    required this.hindiName,
    required this.date,
    required this.nutritionTips,
    required this.specialFoods,
    required this.activityRecommendations,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'englishName': englishName,
        'hindiName': hindiName,
        'date': date.toIso8601String(),
        'nutritionTips': nutritionTips,
        'specialFoods': specialFoods,
        'activityRecommendations': activityRecommendations,
      };

  factory FestivalItem.fromJson(Map<String, dynamic> json) => FestivalItem(
        id: json['id'] as String,
        englishName: json['englishName'] as String,
        hindiName: json['hindiName'] as String,
        date: DateTime.parse(json['date'] as String),
        nutritionTips: json['nutritionTips'] as String,
        specialFoods: json['specialFoods'] as String,
        activityRecommendations: json['activityRecommendations'] as String,
      );
}

@riverpod
class FestivalsList extends _$FestivalsList {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _cacheKey = 'local_festivals_seed_cache';

  @override
  Future<List<FestivalItem>> build() async {
    try {
      final client = ref.read(appwriteClientProvider);
      final tablesDb = TablesDB(client);
      final res = await tablesDb.listRows(
        databaseId: 'fitkarma-db',
        tableId: 'festivals',
      );

      final list = res.rows.map((d) {
        final data = d.data;
        return FestivalItem(
          id: d.$id,
          englishName: data['englishName'] as String? ?? 'Indian Festival',
          hindiName: data['hindiName'] as String? ?? 'भारतीय त्योहार',
          date: data['date'] != null ? DateTime.parse(data['date'] as String) : DateTime.now(),
          nutritionTips: data['nutritionTips'] as String? ?? 'Practice mindful portions.',
          specialFoods: data['specialFoods'] as String? ?? 'Traditional homemade recipes',
          activityRecommendations: data['activityRecommendations'] as String? ?? 'Active community engagement.',
        );
      }).toList();

      if (list.isNotEmpty) {
        _cacheLocally(list);
        return list;
      }
    } catch (_) {}

    return await _loadFallback();
  }

  Future<void> _cacheLocally(List<FestivalItem> items) async {
    try {
      await _storage.write(key: _cacheKey, value: jsonEncode(items.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  Future<List<FestivalItem>> _loadFallback() async {
    try {
      final str = await _storage.read(key: _cacheKey);
      if (str != null) {
        final decoded = jsonDecode(str) as List<dynamic>;
        final parsed = decoded.map((e) => FestivalItem.fromJson(e as Map<String, dynamic>)).toList();
        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
    } catch (_) {}

    final seedArray = [
      FestivalItem(
        id: 'fest_diwali',
        englishName: 'Diwali (Deepavali)',
        hindiName: 'दीपावली',
        date: DateTime(2026, 11, 8),
        nutritionTips: 'Opt for dry fruits instead of deep-fried mawa sweets. Practice mindful portion control during family gatherings.',
        specialFoods: 'Lauki ki Barfi, Roasted Makhana, Saffron Badam Milk',
        activityRecommendations: 'Join community festive walks, traditional rhythmic cleaning routines, or active festive decorating.',
      ),
      FestivalItem(
        id: 'fest_navratri',
        englishName: 'Navratri Devotion',
        hindiName: 'शारदीय नवरात्रि',
        date: DateTime(2026, 10, 10),
        nutritionTips: 'Maintain sustained electrolyte balance during fasting days using sendha namak and fresh multi-fruit bowls.',
        specialFoods: 'Kuttu ki Roti, Samak Chawal Khichdi, Baked Sabudana Tikki',
        activityRecommendations: 'High-energy Garba and Dandiya Raas sessions burning approx ~400 kcal/hr.',
      ),
      FestivalItem(
        id: 'fest_holi',
        englishName: 'Holi Festival of Colors',
        hindiName: 'होली का त्योहार',
        date: DateTime(2026, 3, 3),
        nutritionTips: 'Stay highly hydrated with natural unsweetened coconut water and low-sugar thandai variants.',
        specialFoods: 'Baked Gujiya with dates/jaggery filling, Spiced Kanji drink, Sprouted Moong Chaat',
        activityRecommendations: 'Outdoor color sprint sessions, lively neighborhood dancing routines.',
      ),
      FestivalItem(
        id: 'fest_makar',
        englishName: 'Makar Sankranti',
        hindiName: 'मकर संक्रांति',
        date: DateTime(2026, 1, 14),
        nutritionTips: 'Leverage healthy essential fats from sesame seeds (til) combined with mineral-rich pure organic jaggery.',
        specialFoods: 'Til Ladoo, Multigrain Pongal, Bajra Roti with pure Desi Ghee',
        activityRecommendations: 'Extended outdoor kite flying sessions demanding continuous shoulder mobility and core alignment.',
      ),
    ];

    _cacheLocally(seedArray);
    return seedArray;
  }
}
