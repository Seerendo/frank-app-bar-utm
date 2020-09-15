import 'package:cfhc/models/menu_diario.dart';
import 'package:cfhc/models/producto_bar.dart';
import 'package:cfhc/models/producto_pedido.dart';
import 'package:flutter/cupertino.dart';

class PedidoProvider with ChangeNotifier {  
  Map mapPedidos = Map<int, List<ProductoPedido>>();

  List<ProductoPedido> getPedido(int idBar){
    if(this.mapPedidos.containsKey(idBar)){
      return this.mapPedidos[idBar];
    }else {
      return List<ProductoPedido>();
    }
  }

  double getTotal(int idBar){
    double total = 0;
    for(var i = 0; i < this.mapPedidos[idBar].length; i++){
      total += this.mapPedidos[idBar][i].precio * this.mapPedidos[idBar][i].cantidad;
    }
    return total;
  }

  addSeleccionadoBar(int idBar, ProductoBar prod){
    if(this.mapPedidos.containsKey(idBar)){
      bool existe = false;
      for(var i = 0; i < this.mapPedidos[idBar].length; i++){
        if(this.mapPedidos[idBar][i].id == prod.id){
          existe = true;
          this.mapPedidos[idBar][i].cantidad++;
        }
      }
      if(!existe){
        this.mapPedidos[idBar].add(ProductoPedido.fromProductoBar(prod));
      }
    }else{
      this.mapPedidos[idBar] = List<ProductoPedido>();
      this.mapPedidos[idBar].add(ProductoPedido.fromProductoBar(prod));
    }
    notifyListeners();
  }

  addSeleccionadoMenuDiario(int idBar, MenuDiario prod){
    if(this.mapPedidos.containsKey(idBar)){
      bool existe = false;
      for(var i = 0; i < this.mapPedidos[idBar].length; i++){
        if(this.mapPedidos[idBar][i].id == prod.id_producto){
          existe = true;
          this.mapPedidos[idBar][i].cantidad++;
        }
      }
      if(!existe){
        this.mapPedidos[idBar].add(ProductoPedido.fromMenuDiario(prod));
      }
    }else{
      this.mapPedidos[idBar] = List<ProductoPedido>();
      this.mapPedidos[idBar].add(ProductoPedido.fromMenuDiario(prod));
    }
    notifyListeners();
  }

  removeSeleccionado(int idBar, int id){
    if(this.mapPedidos.containsKey(idBar)){
      for(var i = 0; i < this.mapPedidos[idBar].length; i++){
        if(this.mapPedidos[idBar][i].id == id){
          if(this.mapPedidos[idBar][i].cantidad > 1) {
            this.mapPedidos[idBar][i].cantidad--;
          }else {
            this.mapPedidos[idBar].removeWhere((p) => p.id == id);
          }
          return;
        }
      }
    }
    notifyListeners();
  }

  bool existePedidosBar(int idBar){
    if(this.mapPedidos.containsKey(idBar)){ 
      return true;
    }
    return false;
  }

  String seleccionadosToString(int idBar){
    String pedidos = "";
    double total = 0;
    for(var i = 0; i < this.mapPedidos[idBar].length; i++){
      pedidos += "*[" + this.mapPedidos[idBar][i].nombre + "]* " + "\$" + this.mapPedidos[idBar][i].precio.toString() + " x" + this.mapPedidos[idBar][i].cantidad.toString() + "\n";
      total += this.mapPedidos[idBar][i].precio * this.mapPedidos[idBar][i].cantidad;
    }
    if(pedidos != "") {
      pedidos += "---------------------------------";
      pedidos += "\n*Valor a Pagar:* \$" + total.toString();
    }
    return "\n" + pedidos;
  }

  /* addSeleccionadoBar(ProductoBar prod){
    bool existe = false;
    for(var i = 0; i < seleccionados.length; i++){
      if(seleccionados[i].id == prod.id){
        existe = true;
        seleccionados[i].cantidad++;
      }
    }
    if(!existe){
      seleccionados.add(ProductoPedido.fromProductoBar(prod));
    }
  } */

  /* addSeleccionadoMenuDiario(MenuDiario prod){
    bool existe = false;
    for(var i = 0; i < seleccionados.length; i++){
      if(seleccionados[i].id == prod.id){
        existe = true;
        seleccionados[i].cantidad++;
      }
    }
    if(!existe){
      seleccionados.add(ProductoPedido.fromMenuDiario(prod));
    }
  } */

  /* removeSeleccionado(int id){
    for(var i = 0; i < seleccionados.length; i++){
      if(seleccionados[i].id == id){
        if(seleccionados[i].cantidad > 1) {
          seleccionados[i].cantidad--;
        }else {
          seleccionados.removeWhere((p) => p.id == id);
        }
        return;
      }
    }
  } */

  /* String seleccionadosToString(){
    String pedidos = "";
    double total = 0;
    for(var i = 0; i < seleccionados.length; i++){
      pedidos += "*[" + seleccionados[i].nombre + "]* " + "\$" + seleccionados[i].precio.toString() + " x" + seleccionados[i].cantidad.toString() + "\n";
      total += seleccionados[i].precio * seleccionados[i].cantidad;
    }
    if(pedidos != "") {
      pedidos += "---------------------------------";
      pedidos += "\n*Valor a Pagar:* \$" + total.toString();
    }
    return "\n" + pedidos;
  } */
}