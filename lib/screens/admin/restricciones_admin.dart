import 'package:cfhc/controllers/alergia_ctrl.dart';
import 'package:cfhc/controllers/components_ctrl.dart';
import 'package:cfhc/controllers/ingredientes_ctrl.dart';
import 'package:cfhc/models/alergia.dart';
import 'package:cfhc/models/components.dart';
import 'package:cfhc/models/enfermedad.dart';
import 'package:cfhc/models/estilo_vida.dart';
import 'package:cfhc/models/ingredientes.dart';
import 'package:cfhc/models/producto.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/componentes_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:cfhc/providers/ingredientes_provider.dart';
import 'package:cfhc/providers/producto_provider.dart';
import 'package:cfhc/screens/encuesta/enfermedades.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RestriccionesAdmin extends StatefulWidget {
  RestriccionesAdmin() : super();

  @override
  _RestriccionesAdminState createState() => _RestriccionesAdminState();
}

class _RestriccionesAdminState extends State<RestriccionesAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _agreedToTOS = true;
  String alergia = "";
  EncuestaProvider encuestaProv;
  
  List<DropdownMenuItem> list = List<DropdownMenuItem>();
  List<DropdownMenuItem> list2 = List<DropdownMenuItem>();
  Map dropDownItemsMap;
  Map dropDownItemsMap2;

  Map dropDownItemsMapEstilo;
  Map dropDownItemsMapAlergias;
  Map dropDownItemsMapEnfermedades;
  List<DropdownMenuItem> listEstilo = List<DropdownMenuItem>();
  List<DropdownMenuItem> listAlergia = List<DropdownMenuItem>();
  List<DropdownMenuItem> listEnfermedades = List<DropdownMenuItem>();

  Alergia _selectedAlergias;
  Enfermedad _selectedEnfermedades;
  EstiloVida _selectedEstilo;
  
  Components _selectedItem;
  Producto _selectedItem2;
  ComponenteProvider componenteProvider;
  ProductoProvider productoProvider;

  List<DropdownMenuItem> listCausante = List<DropdownMenuItem>();
  Map dropDownItemsMapCausante;
  String causante = 'Causante';
  String restriccion = 'Restriccion';

  GlobalKey _keyLoader = new GlobalKey();

  List<DropdownMenuItem> getSelectEstiloVida(List<EstiloVida> estilos){ // poner la lista que esta arriba devuelve list
    dropDownItemsMapEstilo = new Map();
    listEstilo.clear();
    estilos.forEach((estilos) {
      int index = estilos.id;
      dropDownItemsMapEstilo[index] = estilos;
      listEstilo.add(new DropdownMenuItem(
        child: Text(estilos.nombre),
        value: estilos.id)
      );
    });
    return listEstilo;
  }

  List<DropdownMenuItem> getSelectAlergias(List<Alergia> als){ // poner la lista que esta arriba devuelve list
    dropDownItemsMapAlergias = new Map();
    listAlergia.clear();
    als.forEach((alergia) {
      int index = alergia.id;
      dropDownItemsMapAlergias[index] = alergia;
      listAlergia.add(new DropdownMenuItem(
        child: Text(alergia.nombre),
        value: alergia.id)
      );
    });
    return listAlergia;
  }

  List<DropdownMenuItem> getSelectEnfermedades(List<Enfermedad> enfer){ // poner la lista que esta arriba devuelve list
    dropDownItemsMapEnfermedades = new Map();
    listEnfermedades.clear();
    enfer.forEach((enfermedad) {
      int index = enfermedad.id;
      dropDownItemsMapEnfermedades[index] = enfermedad;
      listEnfermedades.add(new DropdownMenuItem(
        child: Text(enfermedad.nombre),
        value: enfermedad.id)
      );
    });
    return listEnfermedades;
  }


  List<DropdownMenuItem> getSelectOptions(List<Components> comp){ // poner la lista que esta arriba devuelve list
    dropDownItemsMap = new Map();
    list.clear();
    comp.forEach((componentes) {
      print(componentes.id);
      int index = componentes.id;
      dropDownItemsMap[index] = componentes;
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
      print(productos.id);
      int index = productos.id;
      dropDownItemsMap2[index] = productos;
      list2.add(new DropdownMenuItem(
        child: Text(productos.nombre),
        value: productos.id)
      );
    });
    return list2;
  }

  List<DropdownMenuItem> getCausante(String prueba, List<Alergia> als, List<Enfermedad> enfer, List<EstiloVida> estilos){
    if(prueba == 'Alergias'){
      return getSelectAlergias(als);
    } if(prueba == 'Enfermedades'){
      return getSelectEnfermedades(enfer);
    } else{
      return getSelectEstiloVida(estilos);
    }
  }

  List<TableRow> getIngredientes(List<Ingredientes> ingredientes){ // poner la lista que esta arriba devuelve list
    List<TableRow> tableRows = List<TableRow>();
    ingredientes.forEach((e) { 
      tableRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
            ),
          ),
          children: [
            Text(""+e.producto+" > "+e.componente),
            IconButton(
              icon: Icon(Icons.edit,color: Colors.orange[400]),
              onPressed: () { /*showUpdDialog(context,e.id, e.nombre);*/ }
            ),
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red[400]),
              onPressed: () { /*showAlertDialog(context,e.id);*/ }
            )
        ]),
      );
    });

    return tableRows;
  }

  Widget textoUno(String causante, Alergia als, Enfermedad enfer, EstiloVida estilos){
    if(causante == "Alergias"){
      if(als != null) {
        return Text(als.nombre);
      } else {
        return Text(causante);
      }    
    } if(causante == "Enfermedades"){
      if(enfer != null){
        return Text(enfer.nombre);
      } else{
        return Text(causante);
      }
      
    } else{
      if(estilos != null) {
        return Text(estilos.nombre);
      } else{
        return Text(causante);
      }   
    }
  }

  @override
  Widget build(BuildContext context) {

    componenteProvider = Provider.of<ComponenteProvider>(context);
    productoProvider = Provider.of<ProductoProvider>(context);
    encuestaProv = Provider.of<EncuestaProvider>(context);    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Restricciones'),
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

                    Text('Causante', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: <String>['Alergias', 'Enfermedades', 'Estilo de Vida']
                              .map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                causante = value;
                                setState(() {
                                  causante = value;
                                });
                              },
                              hint: new Text(causante),
                            ),
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
                        child: Selector<EncuestaProvider, List<Alergia>>(
                          selector: (context, model) => model.alergias,
                          builder: (context, alergias, widget) => 
                          Selector<EncuestaProvider, List<Enfermedad>>(
                            selector: (context, model) => model.enfermedades,
                            builder: (context, enfermedades, widget) =>
                            Selector<EncuestaProvider, List<EstiloVida>>(
                              selector: (context, model) => model.estilosVida,
                              builder: (context, estilosVida, widget) => Column(
                                children: <Widget>[
                                  if (alergias.length > 0) ...[
                                    if(enfermedades.length > 0) ...[
                                                                           
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,                                             
                                              items: getCausante(causante, alergias, enfermedades, estilosVida),
                                              onChanged: (value){
                                                if(causante == "Alergias"){
                                                  _selectedAlergias = dropDownItemsMapAlergias[value];
                                                  setState(() {
                                                  _selectedAlergias = dropDownItemsMapAlergias[value];
                                                  });
                                                } if(causante == "Enfermedades") {
                                                  _selectedEnfermedades = dropDownItemsMapEnfermedades[value];
                                                  setState(() {
                                                  _selectedEnfermedades = dropDownItemsMapEnfermedades[value];
                                                  });
                                                } if(causante == "Estilo de Vida"){
                                                  _selectedEstilo = dropDownItemsMapEstilo[value];
                                                  setState(() {
                                                  _selectedEstilo = dropDownItemsMapEstilo[value];
                                                  });
                                                } else{}
                                              },
                                              hint: textoUno(causante, _selectedAlergias, _selectedEnfermedades, _selectedEstilo),
                                            ),
                                          ),
                                        )                              
                                    ]
                                  ],
                                ],
                              ),
                            ),
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

                    Text('Restriccion', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: <String>['Componentes', 'Categoria Alimento']
                              .map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                restriccion = value;
                                setState(() {
                                  restriccion = value;
                                });
                              },
                              hint: new Text(restriccion),
                            ),
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
                        child: Selector<EncuestaProvider, List<Alergia>>(
                          selector: (context, model) => model.alergias,
                          builder: (context, alergias, widget) => 
                          Selector<EncuestaProvider, List<Enfermedad>>(
                            selector: (context, model) => model.enfermedades,
                            builder: (context, enfermedades, widget) =>
                            Selector<EncuestaProvider, List<EstiloVida>>(
                              selector: (context, model) => model.estilosVida,
                              builder: (context, estilosVida, widget) => Column(
                                children: <Widget>[
                                  if (alergias.length > 0) ...[
                                    if(enfermedades.length > 0) ...[
                                                                           
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,                                             
                                              items: getCausante(causante, alergias, enfermedades, estilosVida),
                                              onChanged: (value){
                                                if(causante == "Alergias"){
                                                  _selectedAlergias = dropDownItemsMapAlergias[value];
                                                  setState(() {
                                                  _selectedAlergias = dropDownItemsMapAlergias[value];
                                                  });
                                                } if(causante == "Enfermedades") {
                                                  _selectedEnfermedades = dropDownItemsMapEnfermedades[value];
                                                  setState(() {
                                                  _selectedEnfermedades = dropDownItemsMapEnfermedades[value];
                                                  });
                                                } if(causante == "Estilo de Vida"){
                                                  _selectedEstilo = dropDownItemsMapEstilo[value];
                                                  setState(() {
                                                  _selectedEstilo = dropDownItemsMapEstilo[value];
                                                  });
                                                } else{}
                                              },
                                              hint: textoUno(causante, _selectedAlergias, _selectedEnfermedades, _selectedEstilo),
                                            ),
                                          ),
                                        )                              
                                    ]
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
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