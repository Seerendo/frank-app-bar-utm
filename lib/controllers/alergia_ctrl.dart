import 'package:cfhc/models/alergia.dart';
import 'package:cfhc/services/conf.dart';
import '../models/alergia.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class AlergiaCtrl{
  static Future<bool> registrarAlergia(String alergia) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "alergias",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': alergia  
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarAlergia(int id_alergia, String alergia) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "alergias/"+id_alergia.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': alergia  
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> eliminarAlergia(int idAlergia) async {
    http.Response response = await http.delete(
      GlobalVars.apiUrl + "alergias/"+idAlergia.toString()
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<Alergia>> ListarAlergias() async {
    final response = await http.get(GlobalVars.apiUrl+"alergias");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Alergia>((json) => Alergia.fromJson(json)).toList();
    }
    return null;
  }

}