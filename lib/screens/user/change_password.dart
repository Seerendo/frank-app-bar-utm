import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';

class ChangePass extends StatefulWidget {
  ChangePass() : super();

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Usuario usuario = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 20.0),
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

  String password = '';
  String password2 = '';
  String password3 = '';
  
  bool _obscureText = false;  
  bool _obscureText2 = false;  
  bool _obscureText3 = false;

  @override
  Widget build(BuildContext context) {
    userProv = Provider.of<UsuarioProvider>(context);
    usuario = userProv.getUsuario();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextFormField(
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(fontSize: 16),
            autofocus: false,
            obscureText: !_obscureText,
            decoration: InputDecoration(
              labelText: 'Contraseña Anterior',
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
            onSaved: (value){
              password = value.trimLeft().trimRight();
            },
          ),
          const SizedBox(height: 40.0), 
          TextFormField(   
            style: TextStyle(fontSize: 16),
            obscureText: !_obscureText2,
            decoration: InputDecoration(
              labelText: 'Contraseña Nueva',
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    _obscureText2 = !_obscureText2;
                  });
                },
                child: Icon(
                  _obscureText2 ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText2 ? 'Mostrar Contraseña' : 'Ocultar Contraseña',
                ),
              )
            ),
            validator: FormValidator().validatePassword,
            onSaved: (value){
              password2 = value.trimLeft().trimRight();
            },
          ),
          const SizedBox(height: 10.0), 
          TextFormField(   
            style: TextStyle(fontSize: 16), 
            obscureText: !_obscureText3,
            decoration: InputDecoration(
              labelText: 'Repetir Contraseña',
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    _obscureText3 = !_obscureText3;
                  });
                },
                child: Icon(
                  _obscureText3 ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText3 ? 'Mostrar Contraseña' : 'Ocultar Contraseña',
                ),
              )
            ),
            validator: FormValidator().validatePassword,
            onSaved: (value){
              password3 = value.trimLeft().trimRight();
            },
          ),       
          const SizedBox(height: 30.0),         
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.fromLTRB(20, 12, 20 ,12),
                onPressed: _submittable() ? _submit : null,
                child: const Text(
                  'Actualizar',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
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
      if(password2 == password3) {
        cambiarPass();
      }else{
        _showDialog("Error","Las contraseñas nuevas no coinciden");
      }      
    }    
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  cambiarPass() async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      userProv.cambiarPass(usuario.id_usuario,password,password2).then((value) {
        if (value) {     
          Navigator.of(context).pushReplacementNamed('/login');   
          _showDialog("Información","Contraseña cambiada, inicie sesión de nuevo");
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