import 'package:cfhc/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';

class EditUsuario extends StatefulWidget {
  EditUsuario() : super();

  @override
  _EditUsuarioState createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Usuario usuario = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
          child: RegisterForm(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;
  Usuario usuario = Usuario();  
  UsuarioProvider userProv;

  @override
  Widget build(BuildContext context) {
    userProv = Provider.of<UsuarioProvider>(context);
    usuario = userProv.getUsuario();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20.0), 
          TextFormField(   
            style: TextStyle(fontSize: 20),         
            initialValue: usuario.apellidos,            
            decoration: InputDecoration(              
              labelText: 'Apellidos',
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value){
              setState(() {
                usuario.apellidos = value;
              });
            },
          ),         
          const SizedBox(height: 20.0), 
          TextFormField(
            style: TextStyle(fontSize: 20),
            initialValue: usuario.nombre,
            decoration: InputDecoration(
              labelText: 'Nombres',
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value){
              setState(() {
                usuario.nombre = value;
              });
            },
          ),          
          const SizedBox(height: 30.0),         
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: _submittable() ? _submit : null,
                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                color: Colors.green,
                child: Text(
                  'Actualizar', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();      
      putUsuario();
    }    
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  putUsuario() async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      userProv.actualizarUsuario(usuario).then((value) {
        if (value) {        
          userProv.setUsuario(usuario);
          Navigator.pushNamedAndRemoveUntil(context, '/info_usuario', (_) => false);
          _showDialog("Información","Datos Actualizados con Éxito");
        } else {
          _showDialog("Error","Error al actualizar los datos");
        } 
      });
    }
  }

  void _showDialog(String titulo, String mssg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(titulo),
          content: new Text(mssg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}