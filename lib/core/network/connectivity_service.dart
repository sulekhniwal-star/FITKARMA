import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@riverpod
Stream<List<ConnectivityResult>> connectivityStatus(ConnectivityStatusRef ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
class NetworkNotifier extends _$NetworkNotifier {
  @override
  bool build() {
    // Initial state set by listening to the connectivity status provider
    final status = ref.watch(connectivityStatusProvider).asData?.value;
    return status != null && !status.contains(ConnectivityResult.none);
  }
}
