import 'package:cfhc/controllers/bar_ctrl.dart';
import 'package:cfhc/models/bar.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';

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

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nombre del Local',
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
          TextFormField(
            decoration: const InputDecoration(
              labelText: '# Celular',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value){
              setState(() {
                _bar.celular = value;
              });
            },
          ),
          const SizedBox(height: 16.0),               
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                highlightedBorderColor: Colors.black,
                onPressed: _submittable() ? _submit : null,
                child: const Text('Registrar'),
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
      _bar.id_usuario = usuario.id_usuario;
      _formKey.currentState.save();      
      BarCtrl.registrarBar(_bar);
    }    
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

}