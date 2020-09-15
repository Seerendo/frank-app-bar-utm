import 'package:cfhc/models/bar.dart';
import 'package:cfhc/services/conf.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class BarCtrl{
  static Future<bool> registrarBar(Bar bar) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "bars",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': bar.nombre,
        'celular': bar.celular,
        'id_usuario': bar.id_usuario,
        },
      ),
    ); 
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<Bar>> listarBares() async {
    final response = await http.get(GlobalVars.apiUrl+"bares");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed["data"].map<Bar>((json) => Bar.fromJson(json)).toList();
    }
    return null;
  }

  static Future<Bar> barPorId(String id_bar) async {
    final response = await http.get(GlobalVars.apiUrl+"bares/bar/"+id_bar);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body);
      if(parsed["message"] != null){
        print(parsed["mensaje"]);
        return Bar();
      }
      return Bar.fromJson(parsed);
    }
    return null;
  }

  static Future<Bar> barUsuario(String id_usuario) async {
    print(id_usuario);
    final response = await http.get(GlobalVars.apiUrl+"bares/usuario/"+id_usuario);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body);
      if(parsed["message"] != null){
        print(parsed["mensaje"]);
        return Bar();
      }
      print(parsed);
      if (parsed['data'].length == 0) {
        return Bar();
      }
      return Bar.fromJson(parsed['data'][0]);
    }
    return null;
  }

}