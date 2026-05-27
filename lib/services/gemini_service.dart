import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String defaultModel = 'gemini-2.5-flash';
  static const String _fallbackLiteModel = 'gemini-2.5-flash-lite';
  static const String _endpointPrefix = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Returns the configured Gemini API key from environment.
  /// Throws [StateError] if the key is not available when accessed.
  static String get apiKey {
    final k = dotenv.env['GEMINI_API_KEY'];
    if (k == null || k.isEmpty) {
      throw StateError('GEMINI_API_KEY is not set in environment (.env)');
    }
    return k;
  }

  static String get modelName {
    final configuredModel = dotenv.env['GEMINI_MODEL']?.trim();
    return configuredModel == null || configuredModel.isEmpty ? defaultModel : configuredModel;
  }

  static bool get isConfigured => dotenv.env['GEMINI_API_KEY']?.trim().isNotEmpty == true;

  static Future<String> generateText(
    String prompt, {
    String? model,
  }) async {
    final chosenModel = model ?? modelName;
    try {
      final response = await _postGenerateContent(
        model: chosenModel,
        contents: [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      );
      return _extractText(response);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('(503)') && chosenModel != _fallbackLiteModel) {
        final response = await _postGenerateContent(
          model: _fallbackLiteModel,
          contents: [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        );
        return _extractText(response);
      }
      rethrow;
    }
  }

  static Future<String> analyzeImage(
    Uint8List imageBytes, {
    required String prompt,
    String mimeType = 'image/jpeg',
    String? model,
  }) async {
    final chosenModel = model ?? modelName;
    try {
      final response = await _postGenerateContent(
        model: chosenModel,
        contents: [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
              {
                'inlineData': {
                  'mimeType': mimeType,
                  'data': base64Encode(imageBytes),
                },
              },
            ],
          },
        ],
      );
      return _extractText(response);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('(503)') && chosenModel != _fallbackLiteModel) {
        final response = await _postGenerateContent(
          model: _fallbackLiteModel,
          contents: [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
                {
                  'inlineData': {
                    'mimeType': mimeType,
                    'data': base64Encode(imageBytes),
                  },
                },
              ],
            },
          ],
        );
        return _extractText(response);
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _postGenerateContent({
    required String model,
    required List<Map<String, dynamic>> contents,
  }) async {
    final requestUri = Uri.parse('$_endpointPrefix/$model:generateContent?key=$apiKey');
    final response = await http.post(
      requestUri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{'contents': contents}),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = decoded is Map<String, dynamic> ? decoded['error'] : null;
        final message = error is Map<String, dynamic>
          ? error['message']?.toString() ?? response.body
          : response.body;
      throw StateError('Gemini request failed (${response.statusCode}): $message');
    }

    if (decoded is! Map<String, dynamic>) {
      throw StateError('Gemini returned an unexpected response format');
    }

    return decoded;
  }

  static String _extractText(Map<String, dynamic> response) {
    final candidates = response['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw StateError('Gemini response did not include any candidates');
    }

    final firstCandidate = candidates.first;
    if (firstCandidate is! Map<String, dynamic>) {
      throw StateError('Gemini response candidate was invalid');
    }

    final content = firstCandidate['content'];
    if (content is! Map<String, dynamic>) {
      throw StateError('Gemini response content was invalid');
    }

    final parts = content['parts'];
    if (parts is! List || parts.isEmpty) {
      throw StateError('Gemini response content had no parts');
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map<String, dynamic> && part['text'] is String) {
        buffer.write(part['text'] as String);
      }
    }

    final text = buffer.toString().trim();
    if (text.isEmpty) {
      throw StateError('Gemini response did not contain text output');
    }

    return text;
  }
}
