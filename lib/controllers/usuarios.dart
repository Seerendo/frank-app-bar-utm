import 'package:cfhc/models/actividades.dart';
import 'package:cfhc/models/alergia.dart';
import 'package:cfhc/models/enfermedad.dart';
import 'package:cfhc/models/alimento.dart';
import 'package:cfhc/models/estilo_vida.dart';
import 'package:cfhc/models/preferencia.dart';
import 'package:cfhc/services/conf.dart';
import '../models/usuario.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class UsuarioCtrl{
  static registrarUsuario(Usuario user){

  }

  static actualizarUsuario(Usuario user){

  }

  static cambiarPass(){

  }

  static Future<int> login(email, pass) async {
    http.Response response = await http.post(
      GlobalVars.apiUrl+"login",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'correo': email,
        'pass': pass,
        },
      ),
    ); 
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      int id = data.values.toList()[0];
      return id;
    } else {
      return 0;
    }
  }

  static Future<List<Actividad>> actividadesUsuario(String id) async {
    final response = await http.get(GlobalVars.apiUrl+"actividades_cuarentena/"+id);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Actividad>((json) => Actividad.fromJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deleteActividad(int id_actividad) async {
    final client = http.Client();
    try {
      final response = await http.delete(GlobalVars.apiUrl+"actividades_cuarentena/"+id_actividad.toString());
      if (response.statusCode == 200 ) {
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertActividad(String id_usuario, String actividad) async {
    final response = await http.post(
      GlobalVars.apiUrl+"actividades_cuarentena",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'nombre': actividad,
        },
      ),
    );    
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Alimento>> alimentosUsuario(String id) async {
    final response = await http.get(GlobalVars.apiUrl+"alimentos_cuarentena/"+id);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Alimento>((json) => Alimento.fromJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deleteAlimento(int id_alimento) async {
    final client = http.Client();
    try {
      final response = await http.delete(GlobalVars.apiUrl+"alimentos_cuarentena/"+id_alimento.toString());
      if (response.statusCode == 200 ) {
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertAlimento(String id_usuario, String actividad) async {
    final response = await http.post(
      GlobalVars.apiUrl+"alimentos_cuarentena",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'nombre': actividad,
        },
      ),
    );    
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Alergia>> alergiasUsuario(String id) async {
    final response = await http.get(GlobalVars.apiUrl+"alergias_usuario/usuario/"+id);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Alergia>((json) => Alergia.fromUsuarioAlergiasJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deleteAlergia(String id_usuario, int id_alergia) async {
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl+"alergias_usuario/usuario/"+id_usuario+"/alergia/"+id_alergia.toString())
          )
      );
      if (response.statusCode == 200 ) {
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertAlergia(String id_usuario, Alergia alergia) async {
    final response = await http.post(
      GlobalVars.apiUrl+"alergias_usuario",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'id_alergia': alergia.id,
        },
      ),
    );    
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Enfermedad>> enfermedadesUsuario(String id) async {
    final response = await http.get(GlobalVars.apiUrl+"enfermedades_usuario/usuario/"+id);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Enfermedad>((json) => Enfermedad.fromUsuarioEnfermedadJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deleteEnfermedad(String id_usuario, int id_enfermedad) async {
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl+"enfermedades_usuario/usuario/"+id_usuario+"/enfermedad/"+id_enfermedad.toString()))
      );
      if (response.statusCode == 200 ) {
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertEnfermedad(String id_usuario, Enfermedad enfermedad) async {
    final response = await http.post(
      GlobalVars.apiUrl+"enfermedades_usuario",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'id_enfermedad': enfermedad.id,
        },
      ),
    );    
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<EstiloVida>> estilosVidaUsuario(String id_usuario) async {
    final response = await http.get(GlobalVars.apiUrl+"estilos_vida_usuario/usuario/"+id_usuario);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<EstiloVida>((json) => EstiloVida.fromUsuarioEstiloVidaJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deleteEstiloVida(String id_usuario, String id_estilo) async {
    final client = http.Client();
    try {
      final response = await client.send(
        http.Request("DELETE", Uri.parse(GlobalVars.apiUrl+"estilos_vida_usuario/usuario/"+id_usuario+"/estilo_vida/"+id_estilo.toString()))
      );
      if (response.statusCode == 200 ) {        
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertEstiloVida(String id_usuario, EstiloVida estiloVida) async {
    final response = await http.post(
      GlobalVars.apiUrl+"estilos_vida_usuario",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'id_estilo_vida': estiloVida.id,
        },
      ),
    );    
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Preferencia>> preferenciasUsuario(String id) async {
    final response = await http.get(GlobalVars.apiUrl+"preferencias/usuario/"+id);
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['data'].map<Preferencia>((json) => Preferencia.fromJson(json)).toList();
    }
    return null;
  }

  static Future<bool> deletePreferencia(String id_usuario, String id_categoria) async {
    final client = http.Client();
    try {
      final response = await http.delete(GlobalVars.apiUrl+"preferencias/usuario/"+id_usuario+"/categoria/"+id_categoria);
      if (response.statusCode == 200 ) {
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> insertPreferencia(String id_usuario, Preferencia preferenia) async {
    final response = await http.post(
      GlobalVars.apiUrl+"preferencias",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id_usuario': id_usuario,
        'id_categoria_alimento': preferenia.id_categoria_alimento,
        'valor': preferenia.valor
        },
      ),
    );
    print(response);
    if (response.statusCode == 200 ) {
      return true;
    } else {
      return false;
    }
  }
}