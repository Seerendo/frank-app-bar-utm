import 'package:cfhc/services/conf.dart';
import '../models/estilo_vida.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class EstiloVidaCtrl{
  static Future<bool> registrarEstiloVida(String estilo) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "estilos_vida",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': estilo
        },
      ),
    ); 
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarEstiloVida(int id_estilo, String estilo) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "estilos_vida",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': estilo
        },
      ),
    ); 
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    } 
  }

  static cambiarPass(){

  }

  static Future<List<EstiloVida>> listarEstilosVida() async {
    final response = await http.get(GlobalVars.apiUrl+"estilos_vida");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<EstiloVida>((json) => EstiloVida.fromJson(json)).toList();
    }
    return null;
  }

  static Future<List<EstiloVida>> estilosVidaUsuario(int id_usuario) async {
    final response = await http.get(GlobalVars.apiUrl+"estilos_vida/usuario="+id_usuario.toString());
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<EstiloVida>((json) => EstiloVida.fromJson(json)).toList();
    }
    return null;
  }

}