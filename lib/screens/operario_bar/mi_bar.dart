import 'package:cfhc/controllers/bar_ctrl.dart';
import 'package:cfhc/models/bar.dart';
import 'package:cfhc/models/producto_bar.dart';
import 'package:cfhc/models/usuario.dart';
import 'package:cfhc/partials/left_nav.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MiBar extends StatefulWidget {
  MiBar() : super();

  @override
  _MiBarState createState() => _MiBarState();
}

class _MiBarState extends State<MiBar> {
  GlobalKey<FormState> _key = new GlobalKey();
  Usuario usuario;
  Future<Bar> bar;
  bool existeBar = false;
  Future<List<ProductoBar>> productos;
  BarProvider barProv;

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    barProv = Provider.of<BarProvider>(context);
    bar = BarCtrl.barUsuario(usuario.id_usuario.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Local')
      ),
      drawer: LeftNav().getLeftMenu2(context/* , usuario */),
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit), 
        onPressed: (){
          Navigator.pushNamed(context, '/productos_bar');
      }), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[            
            Container(
              margin: const EdgeInsets.all(20.0),
              child: FutureBuilder<Bar>(
                future: bar,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    barProv.setBar(snapshot.data);
                    /* setState(() {
                      existeBar = true;
                      productos = ProductoCtrl.listarProductosBar(snapshot.data.id.toString());
                    }); */
                    if(snapshot.data.id != null){
                      return Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                snapshot.data.nombre,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 30,),
                              SizedBox(width: 10,),
                              Text(
                                "cell: " + snapshot.data.celular,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: (){
                                    barProv.setBar(snapshot.data);
                                    Navigator.pushNamed(context, '/edit_bar');
                                  },
                                  padding: EdgeInsets.all(12),
                                  color: Colors.greenAccent[700],
                                  child: Text(
                                    'Actualizar Información', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                    ),
                                  ),
                                ), 
                              )                             
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (){
                                  barProv.setBar(snapshot.data);
                                  Navigator.pushNamed(context, '/reg_menu_diario');
                                },
                                padding: EdgeInsets.all(12),
                                color: Colors.redAccent,
                                child: Text(
                                  'Menu Diario', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                  ),
                                ),
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (){
                                  barProv.setBar(snapshot.data);
                                  Navigator.pushNamed(context, '/productos_bar');
                                },
                                padding: EdgeInsets.all(12),
                                color: Colors.lightBlueAccent,
                                child: Text(
                                  'Gestionar Productos', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                  ),
                                ),
                              ),                              ],
                          ),
                        ],
                      );
                        
                    }else{
                      return FlatButton(
                        //highlightedBorderColor: Colors.black,
                        color: Colors.greenAccent,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.green,
                        onPressed: (){
                          Navigator.pushNamed(context, "/registrar_bar");
                        },
                        child: const Text('Registrar Local',style: TextStyle(fontSize: 20.0),),
                      );
                    }                    
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}
