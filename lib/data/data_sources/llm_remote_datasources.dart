import 'dart:convert';

import 'package:cloudwalk_llm/Infrastructure/processor.dart';
import 'package:cloudwalk_llm/domain/entities/chat_completion_entity.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LlmRemoteDataSources extends Processor {
  @override
  Future<ScaffoldEntity> nlpProcessing(
      String prompt, ScaffoldEntity model) async {
    final baseUrl = dotenv.env['BASE_URL'];
    final key = dotenv.env['API_KEY'];
    if (baseUrl == null || key == null) {
      throw Exception(
          'Base URL or API key not found in environment variables.');
    }
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "model": "gemma2-9b-it",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a Flutter widget tree generator. Strictly follow these rules:\n 1. Always output pure JSON only - no markdown, no code fences, no explanations\n2. Remove all escape characters like \n, \", \\ from the output3. Use this exact structure: {type, id, properties, children}4. Colors must be in Flutter format: \"0xAARRGGBB\"\n5. For buttons, use \"child\" property for the button text\n6. Never include any non-JSON text in your response"
        },
        {
          "role": "user",
          "content":
              "${model.toJson()}\n\nInstruction: $prompt"
        }
      ],
      "temperature": 0.7,
      "response_format": {"type": "json_object"}
    });

    final response = await http.post(url, headers: headers, body: body);
    final decodeData = jsonDecode(response.body);
    final chatCompletionEntity = ChatCompletionEntity.fromJson(decodeData);
    final entity = ScaffoldEntity.fromJson(jsonDecode(
      chatCompletionEntity.choices.first.message.content,
    ));
    return entity;
  }
}
