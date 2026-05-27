import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

const String _defaultModel = 'gemini-2.5-flash';
const String _endpointPrefix = 'https://generativelanguage.googleapis.com/v1beta/models';

Future<void> main() async {
  final env = _loadEnv(File('.env'));
  final apiKey = env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    throw StateError('GEMINI_API_KEY is missing from .env');
  }

  final configuredModel = env['GEMINI_MODEL']?.trim();
  final model = (configuredModel == null || configuredModel.isEmpty) ? _defaultModel : configuredModel;
  final text = await _generateText(apiKey, model, 'Reply with exactly: Gemini smoke test passed.');
  stdout.writeln('Text response: $text');

  final pngBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO5F6XQAAAAASUVORK5CYII=',
  );
  final vision = await _analyzeImage(
    apiKey,
    model,
    Uint8List.fromList(pngBytes),
    'Describe the image in one short sentence.',
    'image/png',
  );
  stdout.writeln('Vision response: $vision');
}

Map<String, String> _loadEnv(File file) {
  if (!file.existsSync()) {
    throw StateError('.env file was not found in the project root');
  }

  final env = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#') || !trimmed.contains('=')) {
      continue;
    }
    final index = trimmed.indexOf('=');
    final key = trimmed.substring(0, index).trim();
    final value = trimmed.substring(index + 1).trim();
    if (key.isNotEmpty) {
      env[key] = value;
    }
  }
  return env;
}

Future<String> _generateText(String apiKey, String model, String prompt) async {
  final response = await http.post(
    Uri.parse('$_endpointPrefix/$model:generateContent?key=$apiKey'),
    headers: const {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt},
          ],
        },
      ],
    }),
  );
  return _extractText(response);
}

Future<String> _analyzeImage(
  String apiKey,
  String model,
  Uint8List imageBytes,
  String prompt,
  String mimeType,
) async {
  final response = await http.post(
    Uri.parse('$_endpointPrefix/$model:generateContent?key=$apiKey'),
    headers: const {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
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
    }),
  );
  return _extractText(response);
}

String _extractText(http.Response response) {
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

  final candidates = decoded['candidates'];
  if (candidates is! List || candidates.isEmpty) {
    throw StateError('Gemini response did not include any candidates');
  }

  final content = (candidates.first as Map<String, dynamic>)['content'];
  final parts = (content as Map<String, dynamic>)['parts'];
  final buffer = StringBuffer();
  for (final part in parts as List) {
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
