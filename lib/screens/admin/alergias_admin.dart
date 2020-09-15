import 'package:cfhc/controllers/alergia_ctrl.dart';
import 'package:cfhc/models/alergia.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AlergiasAdmin extends StatefulWidget {
  AlergiasAdmin() : super();

  @override
  _AlergiasAdminState createState() => _AlergiasAdminState();
}

class _AlergiasAdminState extends State<AlergiasAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final colorFondo = Colors.amber;
  final colorSuave = Colors.amber[300];
  final colorFuerte = Colors.amber[600];
  final colorLista = Colors.amber[50];

  bool _agreedToTOS = true;
  String alergia = "";
  EncuestaProvider encuestaProv;

  GlobalKey _keyLoader = new GlobalKey();

  List<TableRow> getAlergiass(List<Alergia> als){ // poner la lista que esta arriba devuelve list
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
        title: const Text('Admin Alergias'),
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
                            alergia = value;
                          });
                        },                     
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Alergia',
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
                          AlergiaCtrl.registrarAlergia(alergia).then((value) {
                            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                            if (value) {
                              encuestaProv.listarAlergias();
                              Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito la alergia");
                            } else {
                              Dialogs.mostrarDialog(context, "Error", "Error al registrar la alergia");
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
                  Selector<EncuestaProvider,List<Alergia>>(
                    selector: (context, model) => model.alergias,
                    builder: (context, alergias, widget) => Column(
                      children: <Widget>[
                        if (alergias.length > 0) ...[
                          Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {                  
                              0: FlexColumnWidth(1),
                              1: FixedColumnWidth(40),
                              2: FixedColumnWidth(40),
                            },
                            children: 
                              getAlergiass(alergias)
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

  showAlertDialog(BuildContext context, int idAlergia) {
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
          AlergiaCtrl.eliminarAlergia(idAlergia).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              encuestaProv.listarAlergias();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Alergia eliminada con éxito");
            }else {
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Error", "Error al eliminar");
            }
          });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar Alergia"),
      content: Text("¿Estas seguro de eliminar esta alergia?"),
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

  showUpdDialog(BuildContext context, int idAlergia, String aler) {
    final GlobalKey<FormState> _uKey = GlobalKey<FormState>();
    String uAlergia = "";
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
          AlergiaCtrl.actualizarAlergia(idAlergia, uAlergia).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              encuestaProv.listarAlergias();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Alergia actualizada con éxito");
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
      title: Text("Actualizar Alergia"),
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
              uAlergia = value;
            });
          },                     
          decoration: const InputDecoration(
            fillColor: Colors.white,
            hintText: 'Alergia',
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