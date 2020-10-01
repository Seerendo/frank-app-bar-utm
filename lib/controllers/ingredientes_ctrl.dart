import 'package:cfhc/models/components.dart';
import 'package:cfhc/models/ingredientes.dart';
import 'package:cfhc/models/producto.dart';
import 'package:cfhc/services/conf.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class IngredientesCtrl{
  static Future<bool> registrarIngredientes(Components comp, Producto prod) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl + "componentes_producto",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "id_producto": prod.id,
        "id_componente": comp.id
        },
      ),
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<bool> actualizarIngredientes(int id, String comp) async { //Por Modificar
    http.Response response = await http.put(
      GlobalVars.apiUrl + "componentes/"+id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'nombre': comp  
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }

  static Future<List<Ingredientes>> listarIngredientes() async {
    final response = await http.get(GlobalVars.apiUrl+"componentes_producto");
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      print("object");
      return parsed["data"].map<Ingredientes>((json) => Ingredientes.fromJson(json)).toList();
    }
    return null;
  }

    static Future<bool> eliminarIngrediente(int idProducto, int idComponente) async {
    http.Response response = await http.delete(
      GlobalVars.apiUrl + "componentes_producto/producto/"+idProducto.toString() + "/componente/"+idComponente.toString()
    ); 
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } 
  }
}