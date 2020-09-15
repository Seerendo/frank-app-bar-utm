import 'package:cfhc/models/categoria_alimento.dart';
import 'package:cfhc/services/conf.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class CategoriaAlimentoCtrl{
  static Future<bool> registrarCategoriaAlimento(CategoriaAlimento CategoriaAlimento) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "categorias_alimento",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'nombre': CategoriaAlimento.nombre,
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> registrarCategoriaAlimento2(String cat) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "categorias_alimento",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'nombre': cat,
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarCategoriaAlimento(int id, String cat) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "categorias_alimento/"+id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': cat  
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> eliminarCategoriaAlimento(int id) async {
    http.Response response = await http.delete(
      GlobalVars.apiUrl + "categorias_alimento/"+id.toString()
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<CategoriaAlimento>> listarCategoriaAlimentos() async {
    final response = await http.get(GlobalVars.apiUrl+"categorias_alimento");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<CategoriaAlimento>((json) => CategoriaAlimento.fromJson(json)).toList();
    }
    return null;
  }

}