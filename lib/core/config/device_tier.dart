import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_tier.g.dart';

enum DeviceTier {
  low, // < 2GB RAM
  mid, // 2-4GB RAM
  high, // > 4GB RAM
}

class DeviceTierDetector {
  static Future<DeviceTier> detect() async {
    try {
      if (Platform.isAndroid) {
        // Attempt to read total RAM from /proc/meminfo (reliable on all Android devices)
        try {
          final file = File('/proc/meminfo');
          if (await file.exists()) {
            final lines = await file.readAsLines();
            final memTotalLine = lines.firstWhere((line) => line.startsWith('MemTotal:'));
            final match = RegExp(r'(\d+)').firstMatch(memTotalLine);
            if (match != null) {
              final totalKb = int.parse(match.group(1)!);
              final totalGb = totalKb / (1024 * 1024); // KB to GB
              if (totalGb < 2.0) return DeviceTier.low;
              if (totalGb < 4.5) return DeviceTier.mid; // 2GB to 4GB is mid tier
              return DeviceTier.high;
            }
          }
        } catch (_) {
          // Fallback to basic API if reading proc fails
        }

        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.isLowRamDevice) return DeviceTier.low;
        return DeviceTier.high;
      }
      
      // For iOS, detection is harder without platform channels for RAM, 
      // but usually high-tier for modern iPhones.
      if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        final String model = iosInfo.utsname.machine;
        
        // Simple heuristic: newer iPhones are high tier
        if (model.contains('iPhone12') || 
            model.contains('iPhone13') || 
            model.contains('iPhone14') || 
            model.contains('iPhone15') ||
            model.contains('iPhone16') ||
            model.contains('iPhone17')) {
          return DeviceTier.high;
        }
        return DeviceTier.mid;
      }
    } catch (_) {
      return DeviceTier.mid; // Safe default
    }
    return DeviceTier.mid;
  }
}

@riverpod
Future<DeviceTier> deviceTier(Ref ref) {
  return DeviceTierDetector.detect();
}
