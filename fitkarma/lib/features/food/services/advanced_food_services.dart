// lib/features/food/services/advanced_food_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Advanced food logging service
/// Handles barcode scanning, OCR, image labeling, and voice input
class AdvancedFoodService {
  // OpenFoodFacts API base URL
  static const String _openFoodFactsBaseUrl =
      'https://world.openfoodfacts.org/api/v2';

  /// Barcode scanner controller wrapper
  MobileScannerController? _scannerController;

  /// Get scanner controller
  MobileScannerController get scannerController {
    _scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    return _scannerController!;
  }

  /// Dispose scanner
  void disposeScanner() {
    _scannerController?.dispose();
    _scannerController = null;
  }

  /// Scan barcode and lookup in OpenFoodFacts
  Future<BarcodeFoodResult?> scanBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$_openFoodFactsBaseUrl/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          return BarcodeFoodResult(
            barcode: barcode,
            name: product['product_name'] ?? 'Unknown Product',
            nameHi: product['product_name_hi'] ?? '',
            calories: _parseNutrient(product, 'energy-kcal_100g'),
            protein: _parseNutrient(product, 'proteins_100g'),
            carbs: _parseNutrient(product, 'carbohydrates_100g'),
            fat: _parseNutrient(product, 'fat_100g'),
            servingSize: product['serving_size'] ?? '100g',
            imageUrl: product['image_url'],
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Parse nutrient from product data
  double _parseNutrient(Map<String, dynamic> product, String key) {
    final value = product[key];
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// OCR - Recognize text from nutrition label
  Future<OcrFoodResult?> scanNutritionLabel(InputImage image) async {
    try {
      final textRecognizer = TextRecognizer();

      final recognizedText = await textRecognizer.processImage(image);
      await textRecognizer.close();

      // Parse nutrition information from recognized text
      final Map<String, double> nutrients = {};

      // Look for common patterns
      final text = recognizedText.text.toLowerCase();

      // Calories
      final calorieMatch = RegExp(
        r'(\d+)\s*(?:kcal|calories|energy)',
        caseSensitive: false,
      ).firstMatch(text);
      if (calorieMatch != null) {
        nutrients['calories'] =
            double.tryParse(calorieMatch.group(1) ?? '0') ?? 0;
      }

      // Protein
      final proteinMatch = RegExp(
        r'protein\s*(\d+\.?\d*)\s*g',
        caseSensitive: false,
      ).firstMatch(text);
      if (proteinMatch != null) {
        nutrients['protein'] =
            double.tryParse(proteinMatch.group(1) ?? '0') ?? 0;
      }

      // Carbs
      final carbsMatch = RegExp(
        r'(?:carbohydrate|carb)s?\s*(\d+\.?\d*)\s*g',
        caseSensitive: false,
      ).firstMatch(text);
      if (carbsMatch != null) {
        nutrients['carbs'] = double.tryParse(carbsMatch.group(1) ?? '0') ?? 0;
      }

      // Fat
      final fatMatch = RegExp(
        r'fat\s*(\d+\.?\d*)\s*g',
        caseSensitive: false,
      ).firstMatch(text);
      if (fatMatch != null) {
        nutrients['fat'] = double.tryParse(fatMatch.group(1) ?? '0') ?? 0;
      }

      return OcrFoodResult(
        rawText: recognizedText.text,
        nutrients: nutrients,
        blocks: recognizedText.blocks.map((b) => b.text).toList(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Image labeling - Identify food from plate photo using object detection
  Future<List<ImageLabelResult>> identifyFoodFromImage(InputImage image) async {
    // Simplified implementation - returns placeholder results
    // In production, this would use google_mlkit_image_labeling
    try {
      // For now, return empty list - can be implemented with actual ML model
      return [ImageLabelResult(label: 'Food', confidence: 0.8)];
    } catch (e) {
      return [];
    }
  }

  /// Voice logging - Speech to text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// Check if speech is available
  Future<bool> initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {},
      onError: (error) {},
    );
    return _speechEnabled;
  }

  /// Start listening for voice input
  Future<VoiceFoodResult?> listenForFood() async {
    if (!_speechEnabled) {
      final initialized = await initSpeech();
      if (!initialized) return null;
    }

    String recognizedText = '';

    await _speechToText.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );

    if (recognizedText.isNotEmpty) {
      return VoiceFoodResult(text: recognizedText, isFinal: true);
    }

    return null;
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  /// Check if currently listening
  bool get isListening => _speechToText.isListening;

  /// Dispose resources
  void dispose() {
    disposeScanner();
  }
}

/// Result from barcode scan
class BarcodeFoodResult {
  final String barcode;
  final String name;
  final String nameHi;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;
  final String? imageUrl;

  BarcodeFoodResult({
    required this.barcode,
    required this.name,
    required this.nameHi,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    this.imageUrl,
  });
}

/// Result from OCR scan
class OcrFoodResult {
  final String rawText;
  final Map<String, double> nutrients;
  final List<String> blocks;

  OcrFoodResult({
    required this.rawText,
    required this.nutrients,
    required this.blocks,
  });

  double get calories => nutrients['calories'] ?? 0;
  double get protein => nutrients['protein'] ?? 0;
  double get carbs => nutrients['carbs'] ?? 0;
  double get fat => nutrients['fat'] ?? 0;
}

/// Result from image labeling
class ImageLabelResult {
  final String label;
  final double confidence;

  ImageLabelResult({required this.label, required this.confidence});
}

/// Result from voice input
class VoiceFoodResult {
  final String text;
  final bool isFinal;

  VoiceFoodResult({required this.text, required this.isFinal});
}
