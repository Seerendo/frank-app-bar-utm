import 'package:cfhc/models/enfermedad.dart';
import 'package:cfhc/services/conf.dart';
import '../models/enfermedad.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class EnfermedadCtrl{
  static Future<bool> registrarEnfermedad(String enfermedad) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "enfermedades",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': enfermedad 
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarEnfermedad(int id_enfermedad, String enfermedad) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "enfermedades/"+id_enfermedad.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': enfermedad  
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> eliminarEnfermedad(int idEnfermedad) async {
    http.Response response = await http.delete(
      GlobalVars.apiUrl + "enfermedades/"+idEnfermedad.toString()
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<Enfermedad>> ListarEnfermedades() async {
    final response = await http.get(GlobalVars.apiUrl+"enfermedades");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Enfermedad>((json) => Enfermedad.fromJson(json)).toList();
    }
    return null;
  }

}