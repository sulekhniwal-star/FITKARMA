import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emergency_providers.g.dart';

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'relation': relation,
      };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        relation: json['relation'] as String? ?? 'Family',
      );
}

@riverpod
class EmergencyContacts extends _$EmergencyContacts {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_emergency_contacts_config';

  @override
  List<EmergencyContact> build() {
    _loadContacts();
    return [
      EmergencyContact(name: 'Rohan Sharma', phone: '+91 98765 43210', relation: 'Spouse / Primary Companion'),
      EmergencyContact(name: 'Dr. Vivek Mehta', phone: '+91 91234 56789', relation: 'Family Physician'),
    ];
  }

  Future<void> _loadContacts() async {
    try {
      final data = await _storage.read(key: _storageKey);
      if (data != null) {
        final list = jsonDecode(data) as List<dynamic>;
        final parsed = list.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>)).toList();
        if (parsed.isNotEmpty) {
          final res = parsed.take(2).toList();
          while (res.length < 2) {
            res.add(EmergencyContact(name: 'Unassigned Contact', phone: 'Tap to configure', relation: 'Companion'));
          }
          state = res;
        }
      }
    } catch (_) {}
  }

  Future<void> saveContacts(List<EmergencyContact> updated) async {
    final clamped = updated.take(2).toList();
    state = clamped;
    try {
      await _storage.write(key: _storageKey, value: jsonEncode(clamped.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }
}
