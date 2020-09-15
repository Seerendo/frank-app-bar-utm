import 'package:cfhc/controllers/enfermedad_ctrl.dart';
import 'package:cfhc/models/enfermedad.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EnfermedadesAdmin extends StatefulWidget {
  EnfermedadesAdmin() : super();

  @override
  _EnfermedadesAdminState createState() => _EnfermedadesAdminState();
}

class _EnfermedadesAdminState extends State<EnfermedadesAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final colorFondo = Colors.amber;
  final colorSuave = Colors.amber[300];
  final colorFuerte = Colors.amber[600];
  final colorLista = Colors.amber[50];

  bool _agreedToTOS = true;
  String enfermedad = "";
  EncuestaProvider encuestaProv;

  GlobalKey _keyLoader = new GlobalKey();

  List<TableRow> getEnfermedades(List<Enfermedad> als){ // poner la lista que esta arriba devuelve list
    List<TableRow> tableRows = List<TableRow>();
    als.forEach((e) { 
      tableRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
            ),
          ),
          children: [
            Text(e.nombre),
            IconButton(
              icon: Icon(Icons.edit,color: Colors.orange[400]),
              onPressed: () { showUpdDialog(context,e.id, e.nombre); }
            ),
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red[400]),
              onPressed: () { showAlertDialog(context,e.id); }
            )
        ]),
      );
    });

    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    encuestaProv = Provider.of<EncuestaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Enfermedads'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: LeftNav().getLeftMenu2(context),
      body: SingleChildScrollView(
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10), 
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'No ha ingresado este campo';
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            enfermedad = value;
                          });
                        },                     
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Enfermedad',
                          filled: true,
                          border: OutlineInputBorder(                             
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                        )
                      ) 
                    ),
                    IconButton(
                      color: Colors.green,
                      iconSize: 38,
                      icon: FaIcon(FontAwesomeIcons.solidSave),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");
                          EnfermedadCtrl.registrarEnfermedad(enfermedad).then((value) {
                            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                            if (value) {
                              encuestaProv.listarEnfermedades();
                              Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito la enfermedad");
                            } else {
                              Dialogs.mostrarDialog(context, "Error", "Error al registrar la enfermedad");
                            }
                          });
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Selector<EncuestaProvider,List<Enfermedad>>(
                    selector: (context, model) => model.enfermedades,
                    builder: (context, enfermedades, widget) => Column(
                      children: <Widget>[
                        if (enfermedades.length > 0) ...[
                          Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {                  
                              0: FlexColumnWidth(1),
                              1: FixedColumnWidth(40),
                              2: FixedColumnWidth(40),
                            },
                            children: 
                              getEnfermedades(enfermedades)
                          )
                        ] else ...[
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ]
                      ]
                    ),
                  ), 
                ]
              ) 
            )
          ],
        )
      )
    );
  }

  showAlertDialog(BuildContext context, int idEnfermedad) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Eliminar"),
      onPressed:  () {
        Dialogs.mostrarLoadingDialog(context,_keyLoader, "Actualizando");
          EnfermedadCtrl.eliminarEnfermedad(idEnfermedad).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              encuestaProv.listarEnfermedades();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Enfermedad eliminada con éxito");
            }else {
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Error", "Error al eliminar");
            }
          });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar Enfermedad"),
      content: Text("¿Estas seguro de eliminar esta Enfermedad?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showUpdDialog(BuildContext context, int idEnfermedad, String aler) {
    final GlobalKey<FormState> _uKey = GlobalKey<FormState>();
    String uEnfermedad = "";
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Actualizar"),
      onPressed:  () {
        if (_uKey.currentState.validate()) {
          _uKey.currentState.save();
          Dialogs.mostrarLoadingDialog(context,_keyLoader, "Actualizando");
          EnfermedadCtrl.actualizarEnfermedad(idEnfermedad, uEnfermedad).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              encuestaProv.listarEnfermedades();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Enfermedad actualizada con éxito");
            }else {
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Error", "Error al actualizar");
            }
          });
        }
        //Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Actualizar Enfermedad"),
      content: Form(
        key: _uKey,
        child: TextFormField(
          initialValue: aler, 
          validator: (String value) {
            if (value.trim().isEmpty) {
              return 'No ha ingresado este campo';
            }
          },
          onSaved: (value) {
            setState(() {
              uEnfermedad = value;
            });
          },                     
          decoration: const InputDecoration(
            fillColor: Colors.white,
            hintText: 'Enfermedad',
            filled: true,
            border: OutlineInputBorder(                             
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              ),
            ),
          )
        ) 
      ,),
      actions: [
        cancelButton,
        continueButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}