import 'package:cfhc/models/enfermedad.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:cfhc/controllers/usuarios.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Enfermedades extends StatefulWidget {
  Enfermedades() : super();
/* 
  const RegisterForm({Key key}) : super(key: key);*/

  @override
  _EnfermedadesState createState() => _EnfermedadesState();
}

class _EnfermedadesState extends State<Enfermedades> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final colorFondo = Colors.red;
  final colorSuave = Colors.red[300];
  final colorFuerte = Colors.red[600];
  final colorLista = Colors.red[50];

  bool _agreedToTOS = true;
  String id_usuario ;
  Map dropDownItemsMap;
  Enfermedad _selectedItem;
  List<DropdownMenuItem> list = List<DropdownMenuItem>();
  Future<List<Enfermedad>> enfermedadesUsuario;
  EncuestaProvider encuestaProv;

  GlobalKey _keyLoader = new GlobalKey();

  List<DropdownMenuItem> getSelectOptions(List<Enfermedad> als){ // poner la lista que esta arriba devuelve list
    dropDownItemsMap = new Map();
    list.clear();
    als.forEach((enfermedad) {
      int index = enfermedad.id;
      dropDownItemsMap[index] = enfermedad;
      list.add(new DropdownMenuItem(
        child: Text(enfermedad.nombre),
        value: enfermedad.id)
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    encuestaProv = Provider.of<EncuestaProvider>(context);
    id_usuario = Provider.of<UsuarioProvider>(context).getUsuario().id_usuario.toString();
    enfermedadesUsuario = UsuarioCtrl.enfermedadesUsuario(id_usuario);

    return Scaffold(
      backgroundColor: colorFondo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10), 
            child:   Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Enfermedades',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        color: Colors.white,
                        iconSize: 35,
                        icon: FaIcon(FontAwesomeIcons.penSquare),
                        onPressed: (){
                          Navigator.pushNamed(context, "/registro_enfermedad");
                        },
                      ),
                      Expanded(
                        child: Selector<EncuestaProvider,List<Enfermedad>>(
                          selector: (context, model) => model.enfermedades,
                          builder: (context, enfermedades, widget) => Column(
                            children: <Widget>[
                              if (enfermedades.length > 0) ...[
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: getSelectOptions(enfermedades),
                                      onChanged: (selected) {
                                        _selectedItem = dropDownItemsMap[selected];
                                        setState(() {
                                          _selectedItem = dropDownItemsMap[selected];
                                        });
                                      },
                                      hint: new Text(
                                        _selectedItem != null ? _selectedItem.nombre: "No Seleccionado",
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
                        color: Colors.white,
                        iconSize: 40,
                        icon: FaIcon(FontAwesomeIcons.solidPlusSquare),
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Dialogs.mostrarLoadingDialog(context, _keyLoader, "Registrando");
                            UsuarioCtrl.insertEnfermedad(id_usuario,_selectedItem).then((value){
                              print(value);
                              Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                              if(value == true){                      
                                Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito");                   
                                setState(() {
                                  enfermedadesUsuario = UsuarioCtrl.enfermedadesUsuario(id_usuario);
                                });
                              }else{
                                Dialogs.mostrarDialog(context, "Error", "No se pudo registrar");
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),        
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(20,5, 20, 20),
              decoration: BoxDecoration(
                color: colorLista,
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: FutureBuilder<List<Enfermedad>>(
                future: enfermedadesUsuario,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Lista Vacía',
                              style: TextStyle(
                                color: colorSuave,
                                fontWeight: FontWeight.bold,
                                fontSize: 32
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.listAlt,
                              size: 60,
                              color: colorSuave,
                            )
                          ],
                        )
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          //color: Colors.grey[100],
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              snapshot.data[index].nombre,
                              style: TextStyle(
                                color: colorFuerte,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                            trailing: new IconButton(
                              icon: new FaIcon(FontAwesomeIcons.times,color: Colors.red,),
                              onPressed: () {
                                Dialogs.mostrarLoadingDialog(context, _keyLoader, "Eliminando");
                                UsuarioCtrl.deleteEnfermedad(id_usuario,snapshot.data[index].id).then((value){
                                  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                                  print(value);
                                  if(value == true){                      
                                    Dialogs.mostrarDialog(context, "Éxito", "Se eliminó con éxito");                     
                                    setState(() {
                                      enfermedadesUsuario = UsuarioCtrl.enfermedadesUsuario(id_usuario);
                                    });
                                  }else{
                                    Dialogs.mostrarDialog(context, "Error", "No se pudo eliminar");
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
            child:   Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(    
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Icon(Icons.reply, size: 35, color: colorFuerte),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30))
                  ),
                  onPressed: () => {
                    Navigator.pop(context)
                  },
                ),
                RaisedButton(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorFuerte
                      ),
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/estilos_vida', arguments: id_usuario);
                  },
                )
              ],
            ),
          )
        ],
      )
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
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