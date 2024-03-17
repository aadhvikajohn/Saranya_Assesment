import 'dart:convert';

import 'package:http/http.dart' as http;


import '../model/datamodel.dart';

class TodoService {
  final _baseUrl =  'https://fakestoreapi.com/products';
  final int _limit = 20;
  int _page = 0;
  Future<List<DataModel>> getAll() async {
  //  const url = 'https://fakestoreapi.com/products?limit=10 ';
    final uri = Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final todos = json.map((e) {
        return DataModel(
          id: e['id'],
          title: e['title'],
          category: e['category'],
          image: e['image'],
          price: e['price'],
          rating:  Rating.fromJson(e['rating'])
        );
      }).toList();
      return todos;
    }
    return [];
    // throw "Something went wrong";
  }





}
