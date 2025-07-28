import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AccentColorFetcher {
  static const MethodChannel _channel = MethodChannel('fmac/color');

  static Future<Color> getAccentColor() async {
    try {
      final int colorValue = await _channel.invokeMethod('getAccentColor');
      return Color(colorValue);
    } catch (e) {
      debugPrint("Failed to get accent color: $e");
      return Colors.deepPurple; // fallback
    }
  }
}