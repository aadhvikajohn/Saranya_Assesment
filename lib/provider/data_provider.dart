import 'dart:collection';

import 'package:flutter/material.dart';


import '../model/datamodel.dart';
import '../services/data_services.dart';



class DataProvider extends ChangeNotifier {


  final _service = TodoService();
  bool isLoading = false;
  List<DataModel> _todos = [];
  List<DataModel> get todos => _todos;
  String _searchString = "";
  Future<void> getAllTodos() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getAll();

    _todos = response;
    isLoading = false;
    notifyListeners();
  }






}
