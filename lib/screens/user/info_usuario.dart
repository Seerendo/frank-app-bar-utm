import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';

class InfoUsuario extends StatefulWidget {
  InfoUsuario() : super();

  @override
  _InfoUsuarioState createState() => _InfoUsuarioState();
}

class _InfoUsuarioState extends State<InfoUsuario> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Usuario usuario;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Usuario'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: LeftNav().getLeftMenu2(context/* , usuario */),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit,),
        backgroundColor: Colors.orangeAccent,
        onPressed: (){
          Navigator.pushNamed(context, '/editar_usuario');
      }), 
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
          child: RegisterForm(),
        ),
      ), //
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  Usuario usuario;

  @override
  Widget build(BuildContext context) {    
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[      
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                "Nombres: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                usuario.nombre,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                "Apellidos: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                usuario.apellidos,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                "Correo: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                usuario.correo,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                "Tipo de Usuario: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                usuario.tipo,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )            
          ],
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.orangeAccent,                
                onPressed: (){  
                  Navigator.pushNamed(context, '/editar_usuario');
                },
                child: Text(
                  'Editar Datos',
                  style: TextStyle(fontSize: 24,color: Colors.white),
                ),
              ),
            )            
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.redAccent,
                onPressed: (){  
                  Navigator.pushNamed(context, '/cambiar_pass');
                },
                child: Text(
                  'Cambiar Contraseña',
                  style: TextStyle(fontSize: 24,color: Colors.white),
                ),
              ),
            )            
          ],
        ),
      ],
    );
  }
}