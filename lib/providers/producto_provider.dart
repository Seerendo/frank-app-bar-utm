import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/models/producto.dart';
import 'package:flutter/cupertino.dart';

class ProductoProvider with ChangeNotifier {
  List<Producto> productos = List<Producto>();

  void listarProductos(){
    ProductoCtrl.listarProductos().then((value){
      if(value!=null){
        this.productos = value;
      } else{
        this.productos = List<Producto>();
      }
      notifyListeners();
    });
  }
}