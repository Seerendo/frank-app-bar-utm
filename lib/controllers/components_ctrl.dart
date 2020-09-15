import 'package:cfhc/models/components.dart';
import 'package:cfhc/services/conf.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class ComponentsCtrl{
  static Future<bool> registrarComponentes(String comp) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "componentes",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': comp,
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarComponentes(int id, String comp) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "componentes/"+id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'nombre': comp  
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> eliminarComponente(int id) async {
    http.Response response = await http.delete(
      GlobalVars.apiUrl + "componentes/"+id.toString()
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<Components>> listarComponentes() async {
    final response = await http.get(GlobalVars.apiUrl+"componentes");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed["data"].map<Components>((json) => Components.fromJson(json)).toList();
    }
    return null;
  }

  static Future<Components> componentesPorId(String id_component) async {
    final response = await http.get(GlobalVars.apiUrl+"componentes/"+id_component);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body);
      if(parsed["message"] != null){
        print(parsed["mensaje"]);
        return Components();
      }
      return Components.fromJson(parsed);
    }
    return null;
  }

  static Future<Components> componentesPorNombre(String nombre) async {
    print(nombre);
    final response = await http.get(GlobalVars.apiUrl+"componentes/nombre/"+nombre);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body);
      if(parsed["message"] != null){
        print(parsed["mensaje"]);
        return Components();
      }
      print(parsed);
      if (parsed['data'].length == 0) {
        return Components();
      }
      return Components.fromJson(parsed['data'][0]);
    }
    return null;
  }

}