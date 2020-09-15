import 'package:cfhc/controllers/usuarios.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async'; 

class RootPage extends StatefulWidget {
  RootPage() : super();

  final String title = "hola";

  @override
  _RootPageState createState() => _RootPageState();
}

Future<String> verifySession() async {
  final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "id_usuario");
    return value;
}

class _RootPageState extends State<RootPage> {
  GlobalKey _keyLoader = new GlobalKey();
  UsuarioProvider authProv;

  @override
  Widget build(BuildContext context) {
    authProv = Provider.of<UsuarioProvider>(context);
    authProv.getIdUsuario().then((id_usuario) {
      print("id usuario: ");
      print(id_usuario);
      if(id_usuario != null){
        print("id usuario: " + id_usuario);
        authProv.getInfoUsuario(id_usuario).then((usuario) {          
          // authProv.setUsuario(usuario);
          Navigator.pushNamedAndRemoveUntil(context, '/lista_bares', (_) => false);
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    });
    
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[              
          Center(
            child: Container(
              height: 200,
              child: Image(
                image: AssetImage("assets/images/logo_utm.png"),
                height: 180,
              )
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),  
                strokeWidth: 5,            
              )
            )  
          )          
        ]
      )
    );
  }
}
