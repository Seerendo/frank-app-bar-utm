import 'package:cfhc/controllers/usuarios.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/form_validator.dart';
import '../models/login_request_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async'; 

class Login extends StatefulWidget {
  Login() : super();

  final String title = "hola";

  @override
  _LoginState createState() => _LoginState();
}

Future<String> verifySession() async {
  final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "id_usuario");
    return value;
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey _keyLoader = new GlobalKey();
  bool _validate = false;
  LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;
  UsuarioProvider authProv;
  
  login() async {
    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Iniciando Sesión");
    authProv.logIn(_loginData.email, _loginData.password).then((value) {
      if(value != null){
        if(value.id_usuario == null) {
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          Dialogs.mostrarDialog(context,"Advertencia","Debes Verificar tu correo electrónico");
          return;
        }
        print(value.tipo);
        authProv.setUsuario(value);
        //authProv.saveIdUsuario(value.id_usuario.toString());
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        //Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed('/lista_bares');
        // Navigator.pushNamedAndRemoveUntil(context, '/lista_bares', (_) => false);
      }else{
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        Dialogs.mostrarDialog(context,"Error en el Inicio de Sesión","Usuario o Contraseña Incorrecta");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    authProv = Provider.of<UsuarioProvider>(context);
    
    /* authProv.getIdUsuario().then((id_usuario) {
      print("id usuario: ");
      print(id_usuario);
      if(id_usuario != null){
        print("id usuario: " + id_usuario);
        UsuarioCtrl.getInfoUsuario(id_usuario).then((usuario) {          
          authProv.setUsuario(usuario);
          Navigator.pushNamedAndRemoveUntil(context, '/lista_bares', (_) => false);
        });
      }
    }); */
    
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(    // new line
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[              
            new Container(
              height: 400,
              color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/logo_utm.png"),
                    height: 180,
                  ),
                  SizedBox(height: 10),
                  new Text.rich(
                    TextSpan(
                      text: 'Cognitive Self Service',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white
                      )
                    ),          
                    textAlign : TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,   
                    decoration: BoxDecoration(              
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      )
                    ),   
                  ),
                ],
              )
            ),
            Container(
              padding: new EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: new Form(
                key: _key,
                autovalidate: _validate,
                child: _getFormUI(),
              )            
            ),
          ]
        )
      )
    );
  }

  Widget _getFormUI(){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: 'Correo',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
          validator: FormValidator().validateEmail,
          onSaved: (String value){
            _loginData.email = value;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
          keyboardType: TextInputType.visiblePassword,
          autofocus: false,
          obscureText: _obscureText,
          decoration: InputDecoration(            
            prefixIcon: Icon(Icons.lock),
            hintText: 'Contraseña',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                semanticLabel: _obscureText ? 'Mostrar Contraseña' : 'Ocultar Contraseña',
              ),
            )
          ),
          validator: FormValidator().validatePassword,
          onSaved: (String value){
            _loginData.password = value;
          }
        ),
        SizedBox(height: 20),
        new RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: (){
            if (_key.currentState.validate()) {
              _key.currentState.save();
              print("Email ${_loginData.email}");
              print("Password ${_loginData.password}");

              login();
            } else {
              setState(() {
                _validate = true;
              });
            }
          },
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Text(
            'Iniciar Sesión', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
          ),
        ),        
        SizedBox(height: 5),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('¿No tienes cuenta?,',style: TextStyle(color: Colors.black54)),
            new FlatButton(
              onPressed: (){
                Navigator.pushNamed(context, '/registrar_usuario');
              }, 
              child: Text(
                'Regístrate',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold
                )
              )
            )
          ],
        )        
      ],
    );
  }

}
