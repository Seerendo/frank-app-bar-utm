import 'dart:convert';

import 'package:cfhc/models/tipos_usuario.dart';
import 'package:cfhc/models/usuario.dart';
import 'package:cfhc/services/conf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider with ChangeNotifier {
  Usuario usuario;
  String token;
  String errorMessage;
  bool loading = false;
  final storage = new FlutterSecureStorage();

  Usuario getUsuario(){
    return usuario;
  }

  setUsuario(Usuario user){
    usuario = user;
  }

  setLoading(value){
    loading = value;
    notifyListeners();
  }

  Future<Usuario> logIn(String correo, String pass) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "login",
      headers: <String, String>{
        'Content-Type' : 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email' : correo,
        'password': pass,
        },
      ),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body);
      if(parsed['advertencia'] != null){
        return new Usuario();
      }
      this.token = parsed['success']['token'];
      this.saveIdUsuario(this.token);
      final user = await this.getInfoUsuario(parsed['success']['token']);
      return user;
    }
  }

  Future<Usuario> getInfoUsuario(String id) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "details",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + id
      }
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
      this.token = id;
      this.usuario = Usuario.fromJson(parsed['success']);
      return Usuario.fromJson(parsed['success']);
    }
    return null;
  }

  Future<int> registrarUsuario(Usuario usuario) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "register",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: //json.encode(usuario.toJsonPOST())
      jsonEncode(<String, dynamic>{
        "id_tipo_usuario" : usuario.id_tipo_usuario,
        "apellidos" : usuario.apellidos,
        "nombres" : usuario.nombre,
        "email" : usuario.correo,
        "password" : usuario.pass,
        "c_password" : usuario.pass
        },
      ),
    ); 
    print("sdsd ad ad : "+response.body);
    if (response.statusCode == 200) {
      return 1;
    } else if (response.statusCode == 202) {
      return 2;
    } else {
      return 0;
    } 
  }

  Future<bool> actualizarUsuario(Usuario usuario) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "usuario",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + this.token,
      },
      body: jsonEncode(<String, dynamic>{
        'nombres': usuario.nombre,
        'apellidos': usuario.apellidos
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  Future<bool> cambiarPass(int id, String pass, String passNueva) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "usuario/cambiar_pass",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + this.token,
      },
      body: jsonEncode(<String, dynamic>{
        'password': pass,
        'n_password': passNueva
        },
      ),
    ); 
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.token = null;
      deleteUsuario();
      return true;
    } else {
      return false;
    } 
  }

  Future<String>getIdUsuario() async {
    //final storage = new FlutterSecureStorage();
    return storage.read(key: GlobalVars.idName);
  }

  saveIdUsuario(String id) async {
    //final storage = new FlutterSecureStorage();
    this.token = id;
    await storage.write(key: GlobalVars.idName,value: id);
  }

  deleteUsuario() async {
    //final storage = new FlutterSecureStorage();
    await storage.delete(key: GlobalVars.idName);
  }

  Future<List<TipoUsuario>> listarTiposUsuario() async{
    final response = await http.get(GlobalVars.apiUrl+"tipo_usuario");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed["data"].map<TipoUsuario>((json) => TipoUsuario.fromJson(json)).toList();
    }
    return [];
  }
}