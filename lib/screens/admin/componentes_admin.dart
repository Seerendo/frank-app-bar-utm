import 'package:cfhc/controllers/components_ctrl.dart';
import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/models/components.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/componentes_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ComponentesAdmin extends StatefulWidget {
  ComponentesAdmin() : super();

  @override
  _ComponentesAdminState createState() => _ComponentesAdminState();
}

class _ComponentesAdminState extends State<ComponentesAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _agreedToTOS = true;
  String categoriaAlimento = "";
  EncuestaProvider encuestaProv;
  ComponenteProvider componenteProv;
  ProductoCtrl productoCtrl;


  GlobalKey _keyLoader = new GlobalKey();

  List<TableRow> getComponentes(List<Components> comp){ // poner la lista que esta arriba devuelve list
    List<TableRow> tableRows = List<TableRow>();
    comp.forEach((e) { 
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
    componenteProv = Provider.of<ComponenteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Componentes'),
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
                            categoriaAlimento = value;
                          });
                        },                     
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Registrar Compontentes',
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
                          
                          ComponentsCtrl.registrarComponentes(categoriaAlimento).then((value) {
                            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                            if (value) {
                              componenteProv.listarComponentes();
                              Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito la categoria alimento");
                            } else {
                              componenteProv.listarComponentes();
                              Dialogs.mostrarDialog(context, "Error", "Error al registrar la categoria alimento");
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
                  Selector<ComponenteProvider,List<Components>>(
                    selector: (context, model) => model.componentes,
                    builder: (context, cats, widget) => Column(
                      children: <Widget>[
                        if (cats.length > 0) ...[
                          Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {                  
                              0: FlexColumnWidth(1),
                              1: FixedColumnWidth(40),
                              2: FixedColumnWidth(40),
                            },
                            children: 
                              getComponentes(cats)
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

  showAlertDialog(BuildContext context, int idCategoriaAlimento) {
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
          ComponentsCtrl.eliminarComponente(idCategoriaAlimento).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              componenteProv.listarComponentes();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Categoria Alimento eliminada con éxito");
            }else {
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Error", "Error al eliminar");
            }
          });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar Componente"),
      content: Text("¿Estas seguro de eliminar este Componente?"),
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

  showUpdDialog(BuildContext context, int idCategoriaAlimento, String aler) {
    final GlobalKey<FormState> _uKey = GlobalKey<FormState>();
    String uCategoriaAlimento = "";
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
          ComponentsCtrl.actualizarComponentes(idCategoriaAlimento, uCategoriaAlimento).then((value) {
            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            if (value) {
              componenteProv.listarComponentes();
              Navigator.of(context).pop();
              Dialogs.mostrarDialog(context, "Éxito", "Componente actualizado con éxito");
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
      title: Text("Actualizar Componente"),
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
              uCategoriaAlimento = value;
            });
          },                     
          decoration: const InputDecoration(
            fillColor: Colors.white,
            hintText: 'Componente',
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