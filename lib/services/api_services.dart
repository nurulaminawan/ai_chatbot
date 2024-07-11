import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_chatbot/models/chat_model.dart';
import 'package:ai_chatbot/models/openApi_model.dart';
import 'package:ai_chatbot/utils/app_constant.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<OpenApiModel>> getModel() async {
    try {
      var response = await http.get(
        Uri.parse("${Constants.BASE_URL}/models"),
        headers: {"Authorization": "Bearer ${Constants.API_KEY}"},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        //log("model: $value");
      }
      return OpenApiModel.modelsFromSnapshot(temp);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String msg, required String modelId}) async {
    try {
      var response = await http.post(
          Uri.parse("${Constants.BASE_URL}/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Constants.API_KEY}"
          },
          body:
              jsonEncode({"model": modelId, "prompt": msg, "max_tokens": 100}));

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
