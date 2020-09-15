import 'package:cfhc/controllers/components_ctrl.dart';
import 'package:cfhc/models/components.dart';
import 'package:flutter/cupertino.dart';

class ComponenteProvider with ChangeNotifier {
  List<Components> componentes = List<Components>();

  void listarComponentes(){
    ComponentsCtrl.listarComponentes().then((value){
      if(value!=null){
        this.componentes = value;
      } else{
        this.componentes = List<Components>();
      }
      notifyListeners();
    });
  }
}