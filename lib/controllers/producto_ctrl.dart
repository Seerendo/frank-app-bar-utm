import 'package:cfhc/models/menu_diario.dart';
import 'package:cfhc/models/producto.dart';
import 'package:cfhc/models/producto_bar.dart';
import 'package:cfhc/services/conf.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

class ProductoCtrl{
  static Future<bool> insertProducto(Producto producto) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "productos",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'nombre': producto.nombre,
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> insertProductoBar(String id_bar, String id_prod, double precio) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "lista_productos",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_bar': id_bar,
        'id_producto': id_prod,
        'precio': precio,   
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> deleteProducto(String id_prod,) async {
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl + "productos"))
          ..body = jsonEncode(<String, String>{
            'id_producto': id_prod,   
            },
          ),
        );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      } 
    } finally {
      client.close();
    }
  }

  static Future<bool> deleteProductoBar( String id_bar,String id_prod) async {    
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl + "lista_productos/bar/" + id_bar + "/producto/" + id_prod))
          ..headers['Content-Type'] = 'application/json'
        );
        print(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      } 
    } finally {
      client.close();
    }
  }

  static Future<List<Producto>> listarProductos() async {
    final response = await http.get(GlobalVars.apiUrl+"productos");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed["data"].map<Producto>((json) => Producto.fromJson(json)).toList();
    }
    return null;
  }

  static Future<List<ProductoBar>> listarProductosBar(String id_bar) async {
    final response = await http.get(GlobalVars.apiUrl+"lista_productos/bar/"+id_bar);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<ProductoBar>((json) => ProductoBar.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<MenuDiario>> menuDiarioBar(String id_bar) async {
    final response = await http.get(GlobalVars.apiUrl+"menu_diario/fecha/"+formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd] )+"&id_bar="+id_bar);
    /* print("bar: "+id_bar);
    print("fecha: "+formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd] )); */
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<MenuDiario>((json) => MenuDiario.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<MenuDiario>> menuDiarioBarDiaAnterior(String id_bar) async {
    final response = await http.get(GlobalVars.apiUrl+"menu_diario/fecha/"+formatDate(new DateTime.now().subtract(new Duration(days: 1)), [yyyy, '-', mm, '-', dd] )+"&id_bar="+id_bar);
    print("hola");
    print("bar2: "+formatDate(new DateTime.now().subtract(new Duration(days: 1)), [yyyy, '-', mm, '-', dd] ));
    /*print("fecha: "+formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd] )); */
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<MenuDiario>((json) => MenuDiario.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<Producto>> listarProductosCanDelete() async {
    final response = await http.get(GlobalVars.apiUrl+"productos?can_delete=true");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Producto>((json) => Producto.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> insertProductoMenu(String id_bar, String id_prod, double precio) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "menu_diario",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_bar': id_bar,
        'id_producto': id_prod,
        'precio': precio,
        'fecha': formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd] )
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> deleteProductoMenu( String id_menu_diario) async {    
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl + "menu_diario"))
          ..headers['Content-Type'] = 'application/json'
          ..body = jsonEncode(<String, dynamic>{
            'id_menu_diario': int.parse(id_menu_diario)
            },
          ),
        );
        print(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      } 
    } finally {
      client.close();
    }
  }
}