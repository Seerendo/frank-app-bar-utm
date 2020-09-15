import 'dart:convert';

import 'package:cfhc/models/bar.dart';
import 'package:cfhc/services/conf.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BarProvider with ChangeNotifier {
  Bar bar = Bar();
  List<Bar> listaBar = [];
  String errorMessage;
  bool loading = false;

  Bar getBar (){
    return bar ;
  }

  List<Bar> getListaBar(){
    return listaBar;
  }

  setBar (Bar barr){
    bar  = barr;
  }

  Future<bool> registrarBar(Bar bar) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "bares",
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

  Future<bool> actualizarBar(Bar bar) async {
    http.Response response = await http.put(
      GlobalVars.apiUrl + "bares/"+bar.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': bar.nombre,
        'celular': bar.celular
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  listarBares2(){
    http.get(GlobalVars.apiUrl+"bares").then((value) {
      if (value.statusCode == 200) {
        print(value.body);
        final parsed = json.decode(value.body).cast<Map<String, dynamic>>();
        listaBar = parsed.map<Bar>((json) => Bar.fromJson(json)).toList();
        notifyListeners();
      }
    });    
  }

  Future<List<Bar>> listarBares() async {
    final response = await http.get(GlobalVars.apiUrl+"bares");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Bar>((json) => Bar.fromJson(json)).toList();
    }
    return null;
  }

  Future<Bar> barUsuario(String id_usuario) async {
    final response = await http.get(GlobalVars.apiUrl+"bares/usuario/"+id_usuario);
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

  setBarUsuario(String id_usuario) async {
    http.get(GlobalVars.apiUrl+"bares/usuario/"+id_usuario).then((value) {
      if (value.statusCode == 200) {
        print(value.body);
        final parsed = json.decode(value.body);
        if(parsed["message"] != null){
          bar = Bar();
          notifyListeners();
          return;
        }
        bar = Bar.fromJson(parsed);
        notifyListeners();
      }
    });
  }
}