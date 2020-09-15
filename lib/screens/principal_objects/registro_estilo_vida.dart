import 'package:cfhc/controllers/estilo_vida_ctrl.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroEstiloVida extends StatefulWidget {
  RegistroEstiloVida() : super();

  @override
  _RegitroBarState createState() => _RegitroBarState();
}

class _RegitroBarState extends State<RegistroEstiloVida> {
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar EstiloVida'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
          child: EstiloVidaForm(),
        ),
      ), 
    );
  }
}

class EstiloVidaForm extends StatefulWidget {
  const EstiloVidaForm({Key key}) : super(key: key);

  @override
  _EstiloVidaFormState createState() => _EstiloVidaFormState();
}

class _EstiloVidaFormState extends State<EstiloVidaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String estiloVida = "";
  EncuestaProvider encuestaProv;  
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
              labelText: 'EstiloVida',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
            },
            onSaved: (value){
              setState(() {
                estiloVida = value;
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
                onPressed: (){
                  if (_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");
                    EstiloVidaCtrl.registrarEstiloVida(estiloVida).then((value){
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      if (value) {
                        encuestaProv.listarEstilosVida();
                        Navigator.of(context).pop();
                        Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito el estilo de vida");
                      } else {
                        Dialogs.mostrarDialog(context, "Error", "Error al registrar el estilo de vida");
                      }
                    });
                  } 
                },
                child: const Text('Registrar' ,style: TextStyle(fontSize: 20.0),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog(String tittle, String mssg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(tittle),
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