import 'package:cfhc/controllers/alergia_ctrl.dart';
import 'package:cfhc/controllers/components_ctrl.dart';
import 'package:cfhc/controllers/ingredientes_ctrl.dart';
import 'package:cfhc/models/alergia.dart';
import 'package:cfhc/models/components.dart';
import 'package:cfhc/models/producto.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/componentes_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:cfhc/providers/producto_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class IngredientesAdmin extends StatefulWidget {
  IngredientesAdmin() : super();

  @override
  _IngredientesAdminState createState() => _IngredientesAdminState();
}

class _IngredientesAdminState extends State<IngredientesAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _agreedToTOS = true;
  String alergia = "";
  EncuestaProvider encuestaProv;
  
  List<DropdownMenuItem> list = List<DropdownMenuItem>();
  List<DropdownMenuItem> list2 = List<DropdownMenuItem>();
  Map dropDownItemsMap;
  Map dropDownItemsMap2;
  Components _selectedItem;
  Producto _selectedItem2;
  ComponenteProvider componenteProvider;
  ProductoProvider productoProvider;

  GlobalKey _keyLoader = new GlobalKey();

  List<DropdownMenuItem> getSelectOptions(List<Components> comp){ // poner la lista que esta arriba devuelve list
    dropDownItemsMap = new Map();
    list.clear();
    comp.forEach((componentes) {
      int index = componentes.id;
      print(index);
      dropDownItemsMap[index] = alergia;
      list.add(new DropdownMenuItem(
        child: Text(componentes.nombre),
        value: componentes.id)
      );
    });
    return list;
  }

    List<DropdownMenuItem> getSelectOptions2(List<Producto> prod){ // poner la lista que esta arriba devuelve list
    dropDownItemsMap2 = new Map();
    list2.clear();
    prod.forEach((productos) {
      int index = productos.id;
      dropDownItemsMap2[index] = alergia;
      list2.add(new DropdownMenuItem(
        child: Text(productos.nombre),
        value: productos.id)
      );
    });
    return list2;
  }

  @override
  Widget build(BuildContext context) {
    componenteProvider = Provider.of<ComponenteProvider>(context);
    productoProvider = Provider.of<ProductoProvider>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Ingredientes'),
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
                        child: Selector<ProductoProvider, List<Producto>>(
                          selector: (context, model) => model.productos,
                          builder: (context, productos, widget) => Column(
                            children: <Widget>[
                              if (productos.length > 0) ...[
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: getSelectOptions2(productos),
                                      onChanged: (selected) {
                                        print(dropDownItemsMap[selected]);
                                        _selectedItem2 = dropDownItemsMap[selected];
                                        setState(() {
                                          _selectedItem2 = dropDownItemsMap[selected];
                                        });
                                      },
                                      hint: new Text(
                                        _selectedItem2 != null ? _selectedItem.nombre: "Productos",
                                      ),
                                    ),
                                  )
                                ),
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
                      ),

                    
                  ],
                ),
              ),
            
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10), 
              child: Form(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Expanded(
                        child: Selector<ComponenteProvider, List<Components>>(
                          selector: (context, model) => model.componentes,
                          builder: (context, componentes, widget) => Column(
                            children: <Widget>[
                              if (componentes.length > 0) ...[
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: getSelectOptions(componentes),
                                      onChanged: (selected) {
                                        _selectedItem = dropDownItemsMap2[selected];
                                        setState(() {
                                          _selectedItem = dropDownItemsMap2[selected];
                                        });
                                      },
                                      hint: new Text(
                                        _selectedItem != null ? _selectedItem.nombre: "Componentes",
                                      ),
                                    ),
                                  )
                                ),
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
                      ),
                      IconButton(
                      color: Colors.green,
                      iconSize: 38,
                      icon: FaIcon(FontAwesomeIcons.solidSave),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");
                          
                          IngredientesCtrl.registrarIngredientes(_selectedItem, _selectedItem2).then((value) {
                            Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                            if (value) {
                              componenteProvider.listarComponentes();
                              Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito la categoria alimento");
                            } else {
                              componenteProvider.listarComponentes();
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