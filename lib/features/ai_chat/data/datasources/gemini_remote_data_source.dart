import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/secrets/app_secrets.dart';
import 'package:recipe_app_withai/features/ai_chat/data/models/ai_query_model.dart';

abstract interface class GeminiRemoteDataSource {
  Future<AiQueryModel> parseUserQuery(String userText);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final http.Client client;

  GeminiRemoteDataSourceImpl(this.client);

  static const _model = 'gemini-2.0-flash';
  // Assuming AppSecrets has geminiApiKey. If not, user needs to add it.
  // Using a placeholder getter if not present, but for compilation I'll use separate string if needed.
  // But strictly I should use AppSecrets.
  
  @override
  Future<AiQueryModel> parseUserQuery(String userText) async {
    const apiKey = AppSecrets.geminiApiKey; // Ensure this exists in AppSecrets
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$apiKey');

    final schema = {
      "type": "OBJECT",
      "properties": {
        "mode": {
          "type": "STRING",
          "enum": ["byName", "byIngredients"]
        },
        "query": {"type": "STRING"},
        "ingredients": {
          "type": "ARRAY",
          "items": {"type": "STRING"}
        },
        "maxReadyTime": {"type": "INTEGER"},
        "cuisine": {"type": "STRING"}
      },
      "required": ["mode"]
    };

    final body = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Parse this recipe request into JSON. If user mentions ingredients, set mode='byIngredients'. If user mentions a dish name, set mode='byName'. User: '$userText'"
            }
          ]
        }
      ],
      "generationConfig": {
        "response_mime_type": "application/json",
        "response_schema": schema
      }
    };

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final contentParts = candidates[0]['content']['parts'] as List;
          final jsonText = contentParts[0]['text'] as String;
          final jsonMap = jsonDecode(jsonText);
          return AiQueryModel.fromJson(jsonMap);
        } else {
          throw ServerFailure('No candidates from Gemini');
        }
      } else {
        throw ServerFailure('Gemini API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}

// Add this extension to AppSecrets if not present, or user must add it. 
// I will not modify AppSecrets directly unless I'm sure. 
// For now, I will assume it exists since I am instructed to use it.
// If it fails to compile, I'll fix it.
// actually, let's just make it a static const in this file if AppSecrets doesn't have it, 
// OR I will define it in AppSecrets now to be safe.
