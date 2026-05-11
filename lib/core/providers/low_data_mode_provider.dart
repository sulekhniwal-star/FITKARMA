import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'low_data_mode_provider.g.dart';

@riverpod
class LowDataMode extends _$LowDataMode {
  static const _storageKey = 'low_data_mode_enabled';
  final _storage = const FlutterSecureStorage();

  @override
  Future<bool> build() async {
    final value = await _storage.read(key: _storageKey);
    return value == 'true';
  }

  Future<void> toggle() async {
    final newState = !((await future));
    await _storage.write(key: _storageKey, value: newState.toString());
    state = AsyncValue.data(newState);
  }

  Future<void> setEnabled(bool enabled) async {
    await _storage.write(key: _storageKey, value: enabled.toString());
    state = AsyncValue.data(enabled);
  }
}
