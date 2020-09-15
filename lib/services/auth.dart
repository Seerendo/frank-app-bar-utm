import 'dart:async';
import 'dart:ffi';
import 'package:cfhc/services/conf.dart';

import '../models/usuario.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static logIn(String correo, String pass) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "login.php",
      headers: <String, String>{
        'Content-Type' : 'application/json',
      },
      body: jsonEncode(<String, String>{
        'correo' : correo,
        'pass': pass,
        },
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String id = data.values.toList()[0].toString();

      return id;
    }
  }

  static Future getIdUsuario() async {
    final storage = new FlutterSecureStorage();
    await Future.sync(()  async =>  await storage.read(key: 'id_usuario'));
    /* String id = await storage.read(key: "id_usuario");
    return id; */
  }

  static saveIdUsuario(String id) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "id_usuario",value: id);
  }

  static deleteUsuario() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "id_usuario");
  }

  static Future<Usuario> getInfoUsuario(int id) async {
    final response = await http.get("http://192.168.1.13/api/usuarios.php?id_usuario="+id.toString());
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return Usuario.fromJson(parsed);
    }
    return null;
  }
} 
