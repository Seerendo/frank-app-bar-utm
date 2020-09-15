import 'package:cfhc/controllers/categoria_alimento_ctrl.dart';
import 'package:cfhc/models/categoria_alimento.dart';
import 'package:cfhc/models/preferencia.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:cfhc/controllers/usuarios.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Preferencias extends StatefulWidget {
  Preferencias() : super();
/* 
  const RegisterForm({Key key}) : super(key: key);*/

  @override
  _PreferenciasState createState() => _PreferenciasState();
}

class _PreferenciasState extends State<Preferencias> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final colorFondo = Colors.purple;
  final colorSuave = Colors.purple[300];
  final colorFuerte = Colors.purple[600];
  final colorLista = Colors.purple[50];

  bool _agreedToTOS = true;
  String id_usuario ;
  Map dropDownItemsMap;
  CategoriaAlimento _selectedItem;
  List<DropdownMenuItem> list = List<DropdownMenuItem>();
  Future<List<CategoriaAlimento>> categoriaAlimentos;
  Future<List<Preferencia>> preferenciasUsuario;
  EncuestaProvider encuestaProv;
  int _valor = null;

  GlobalKey _keyLoader = new GlobalKey();

  List<DropdownMenuItem> getSelectOptions(List<CategoriaAlimento> als){ // poner la lista que esta arriba devuelve list
    dropDownItemsMap = new Map();
    list.clear();
    als.forEach((item) {
      int index = item.id;
      dropDownItemsMap[index] = item;
      list.add(new DropdownMenuItem(
        child: Text(item.nombre),
        value: item.id)
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    encuestaProv = Provider.of<EncuestaProvider>(context);
    id_usuario = Provider.of<UsuarioProvider>(context).getUsuario().id_usuario.toString();
    categoriaAlimentos = CategoriaAlimentoCtrl.listarCategoriaAlimentos();
    preferenciasUsuario = UsuarioCtrl.preferenciasUsuario(id_usuario);

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
                    'Preferencias',
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
                      Expanded(
                        child: FutureBuilder<List<CategoriaAlimento>>(
                          future: categoriaAlimentos,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return new Container();
                            } else if (snapshot.hasData) {
                              list.clear();
                              dropDownItemsMap = new Map();

                              snapshot.data.forEach((item) {
                                int index = item.id;
                                dropDownItemsMap[index] = item;

                                list.add(new DropdownMenuItem(
                                  child: Text(item.nombre),
                                  value: item.id));
                              });

                              return Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: list,
                                    onChanged: (selected) {
                                      _selectedItem = dropDownItemsMap[selected];
                                      setState(() {
                                        _selectedItem = dropDownItemsMap[selected];
                                      });
                                    },
                                    hint: new Text(
                                      _selectedItem != null ? _selectedItem.nombre: "No Seleccionado",
                                      //style: new TextStyle(color: Colors.blue),
                                    ),
                                  )
                                )
                              );                              
                            } else {
                              return Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),            
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child:DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: [
                              DropdownMenuItem(child: Text('1'),value: 1),
                              DropdownMenuItem(child: Text('2'),value: 2),
                              DropdownMenuItem(child: Text('3'),value: 3),
                              DropdownMenuItem(child: Text('4'),value: 4),
                              DropdownMenuItem(child: Text('5'),value: 5)
                            ],
                            onChanged: (selected) {
                              _valor = selected;
                              setState(() {
                                _valor = selected;
                              });
                            },
                            hint: new Text(
                              _valor != null ? _valor.toString() : "-",
                              //style: new TextStyle(color: Colors.blue),
                            ),
                          )
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        iconSize: 40,
                        icon: FaIcon(FontAwesomeIcons.solidPlusSquare),
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Preferencia pref = Preferencia(
                              id_categoria_alimento: _selectedItem.id,
                              id_usuario: int.parse(id_usuario),
                              nombre: _selectedItem.nombre,
                              valor: _valor/* int.parse(_valor.trim()) */
                            );
                            Dialogs.mostrarLoadingDialog(context, _keyLoader, "Registrando");
                            UsuarioCtrl.insertPreferencia(id_usuario,pref).then((value){
                              print(value);
                              Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                              if(value == true){                      
                                Dialogs.mostrarDialog(context, "Éxito", "Se registró con éxito");                   
                                setState(() {
                                  preferenciasUsuario = UsuarioCtrl.preferenciasUsuario(id_usuario);
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
              child: FutureBuilder<List<Preferencia>>(
                future: preferenciasUsuario,
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
                            subtitle: Text(
                              "Preferencia: " + snapshot.data[index].valor.toString(),
                              style: TextStyle(
                                color: colorFuerte,
                              ),
                            ),
                            trailing: new IconButton(
                              icon: new FaIcon(FontAwesomeIcons.times,color: Colors.red,),
                              onPressed: () {
                                Dialogs.mostrarLoadingDialog(context, _keyLoader, "Eliminando");
                                UsuarioCtrl.deletePreferencia(id_usuario,snapshot.data[index].id_categoria_alimento.toString()).then((value){
                                  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                                  print(value);
                                  if(value == true){                      
                                    Dialogs.mostrarDialog(context, "Éxito", "Se eliminó con éxito");                     
                                    setState(() {
                                      preferenciasUsuario = UsuarioCtrl.preferenciasUsuario(id_usuario);
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
                    Navigator.pushNamed(context, '/alimentos_cuarentena', arguments: id_usuario);
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