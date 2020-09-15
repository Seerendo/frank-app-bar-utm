import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/models/bar.dart';
import 'package:cfhc/models/producto_bar.dart';
import 'package:cfhc/models/producto_pedido.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:cfhc/providers/pedido_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class VistaBar extends StatefulWidget {
  VistaBar() : super();

  @override
  _VistaBarState createState() => _VistaBarState();
}

class _VistaBarState extends State<VistaBar> {
  GlobalKey<FormState> _key = new GlobalKey();
  Bar bar;
  bool existeBar = false;
  Future<List<ProductoBar>> productos;
  //List<ProductoPedido> seleccionados = List<ProductoPedido>();
  BarProvider barProv;
  PedidoProvider pedidoProv;

  @override
  Widget build(BuildContext context) {
    bar = ModalRoute.of(context).settings.arguments;
    pedidoProv = Provider.of<PedidoProvider>(context);
    productos = ProductoCtrl.listarProductosBar(bar.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(bar.nombre)
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[            
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Productos Generales",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Para ver los productos disponibles el día de hoy entra a Menú del Día",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16
                          ),
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(          
              child: FutureBuilder<List<ProductoBar>>(
                future: productos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    return Text("No tiene Productos");
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    if(snapshot.data.length == 0){
                      return Text("No tiene Productos");
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card( 
                          child: ListTile(
                            leading: Text(
                              "\$ " + snapshot.data[index].precio.toString(),
                              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            title: Text(snapshot.data[index].nombre),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.green,
                              ),
                              onPressed: (){
                                setState(() {
                                  //addSeleccionado(snapshot.data[index]);
                                  pedidoProv.addSeleccionadoBar(bar.id, snapshot.data[index]);
                                });
                              }
                            )
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Selector<PedidoProvider,List<ProductoPedido>>(
              selector: (buildContext, model) => model.getPedido(bar.id),
              builder: (context, pedidos, widget) => Column(
                children: <Widget>[
                  if (pedidos.length > 0) ...[
                    Column(
                      children: <Widget>[
                        Text(
                          "Productos Pedidos:   \$" + pedidoProv.getTotal(bar.id).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        Container(
                          height: 170,
                          child: ListView.builder(
                            itemCount: pedidoProv.getPedido(bar.id).length,
                            itemBuilder: (context, index) {
                              return Card( 
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[                                      
                                      /* Text(
                                        "\$ " + pedidos[index].precio.toString(),
                                        style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
                                      ), */
                                      Text(
                                        "x" + pedidos[index].cantidad.toString(),
                                        style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$ " + (pedidos[index].precio * pedidos[index].cantidad).toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(pedidos[index].nombre),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.remove_shopping_cart,
                                      color: Colors.red,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        pedidoProv.removeSeleccionado(bar.id,pedidoProv.getPedido(bar.id)[index].id);
                                      });
                                    }
                                  )
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ]
                ]
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/menu_diario', arguments: bar);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.redAccent,
                  icon: Icon(Icons.restaurant_menu,color: Colors.white,),
                  label: Text(
                    'Menú del Día', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: (){
                    if(!pedidoProv.existePedidosBar(bar.id)) {
                      Dialogs.mostrarDialog(context, "Notificación", "No tienes pedidos de este Bar"); 
                      return;
                    }
                    FlutterOpenWhatsapp.sendSingleMessage(
                      "593" + bar.celular, 
                      //"Hola, quisiera realizar un pedido; " + seleccionadosToString()
                      "Hola, quisiera realizar un pedido; " + pedidoProv.seleccionadosToString(bar.id)
                    );                          
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.green,
                  icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,),
                  label: Text(
                    'Pedir', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      //),
    );
  }
}
