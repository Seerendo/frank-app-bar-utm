import 'package:cfhc/models/components.dart';
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
}