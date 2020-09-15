import 'package:cfhc/models/usuario.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bar.dart';

class RegistroBar extends StatefulWidget {
  RegistroBar() : super();

  @override
  _RegitroBarState createState() => _RegitroBarState();
}

class _RegitroBarState extends State<RegistroBar> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Bar'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
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
  Bar _bar = Bar();
  Usuario usuario;
  BarProvider barProv;
  GlobalKey _keyLoader = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    barProv = Provider.of<BarProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration( 
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Nombre del Bar',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value){
              setState(() {
                _bar.nombre = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_android),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: '# Celular',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
              if(value.trim().length != 10 ){
                return 'Ingrese un Número Móvil correcto (sin +593)';
              }
            },
            onSaved: (value){
              setState(() {
                _bar.celular = value.trim();
              });
            },
          ),
          const SizedBox(height: 16.0),               
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: (){
                  if (_formKey.currentState.validate()){
                    _bar.id_usuario = usuario.id_usuario;
                    _formKey.currentState.save();
                    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");                    
                    barProv.registrarBar(_bar).then((value){
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      Navigator.pushNamedAndRemoveUntil(context, '/mi_bar', (_) => false, arguments: usuario);
                    });
                  }
                },
                padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                color: Colors.green,
                child: Text(
                  'Registrar', 
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

}