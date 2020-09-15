import 'package:cfhc/models/usuario.dart';
import 'package:flutter/cupertino.dart';

class UsuarioProvider2 with ChangeNotifier {
  Usuario usuario;
  String errorMessage;
  bool loading = false;

  Future<bool> fetchUsuario(){
    setLoading(true);

    
  }

  setLoading(value){
    loading = value;
    notifyListeners();
  }
}