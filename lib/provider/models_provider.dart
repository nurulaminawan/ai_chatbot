
import 'package:ai_chatbot/models/openApi_model.dart';
import 'package:ai_chatbot/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class ModelProvider with ChangeNotifier {
  String currentModel = "text-davinci-001";
  String get getCurrentModel => currentModel;

  List<OpenApiModel> modelList = [];
  List<OpenApiModel> get getModelList => modelList;

  void setCurrentModel(String model) {
    currentModel = model;
    notifyListeners();
  }

  Future<List<OpenApiModel>> getAllModels() async {
    modelList = await ApiServices.getModel();
    return modelList;
  }
}
