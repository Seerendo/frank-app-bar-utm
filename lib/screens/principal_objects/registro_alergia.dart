import 'package:cfhc/controllers/alergia_ctrl.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroAlergia extends StatefulWidget {
  RegistroAlergia() : super();

  @override
  _RegitroBarState createState() => _RegitroBarState();
}

class _RegitroBarState extends State<RegistroAlergia> {
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Alergia'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
          child: AlergiaForm(),
        ),
      ),
    );
  }
}

class AlergiaForm extends StatefulWidget {
  const AlergiaForm({Key key}) : super(key: key);

  @override
  _AlergiaFormState createState() => _AlergiaFormState();
}

class _AlergiaFormState extends State<AlergiaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EncuestaProvider encuestaProv;
  String alergia = "";
  GlobalKey _keyLoader = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    encuestaProv = Provider.of<EncuestaProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Alergia',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value) {
              setState(() {
                alergia = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.greenAccent,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");
                    AlergiaCtrl.registrarAlergia(alergia).then((value) {
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      if (value) {
                        encuestaProv.listarAlergias();
                        Navigator.of(context).pop();
                        Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito la alergia");
                      } else {
                        Dialogs.mostrarDialog(context, "Error", "Error al registrar la alergia");
                      }
                    });
                  }
                },
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
