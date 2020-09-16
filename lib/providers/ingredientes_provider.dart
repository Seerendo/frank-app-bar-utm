import 'package:cfhc/controllers/ingredientes_ctrl.dart';
import 'package:cfhc/models/ingredientes.dart';
import 'package:flutter/cupertino.dart';

class IngredientesProvider with ChangeNotifier {
  List<Ingredientes> ingredientes = List<Ingredientes>();

  void listarIngredientes(){
    IngredientesCtrl.listarIngredientes().then((value){
      if(value!=null){
        this.ingredientes = value;
      } else{
        this.ingredientes = List<Ingredientes>();
      }
      notifyListeners();
    });
  }
}