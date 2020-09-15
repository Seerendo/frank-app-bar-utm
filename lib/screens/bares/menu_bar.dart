import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/models/bar.dart';
import 'package:cfhc/models/menu_diario.dart';
import 'package:cfhc/models/producto_pedido.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:cfhc/providers/pedido_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuDiarioBar extends StatefulWidget {
  MenuDiarioBar() : super();

  @override
  _MenuDiarioBarState createState() => _MenuDiarioBarState();
}

class _MenuDiarioBarState extends State<MenuDiarioBar> {
  GlobalKey<FormState> _key = new GlobalKey();
  Bar bar;
  bool existeBar = false;
  Future<List<MenuDiario>> productos;
  BarProvider barProv;
  PedidoProvider pedidoProv;

  /* addSeleccionado(MenuDiario prod){
    bool existe = false;
    for(var i = 0; i < seleccionados.length; i++){
      if(seleccionados[i].id == prod.id){
        existe = true;
        seleccionados[i].cantidad++;
      }
    }
    if(!existe){
      seleccionados.add(ProductoPedido.fromMenuDiario(prod));
    }
  }

  removeSeleccionado(int id){
    for(var i = 0; i < seleccionados.length; i++){
      if(seleccionados[i].id == id){
        if(seleccionados[i].cantidad > 1) {
          seleccionados[i].cantidad--;
        }else {
          seleccionados.removeWhere((p) => p.id == id);
        }
        return;
      }
    }
  }

  String seleccionadosToString(){
    String pedidos = "";
    double total = 0;
    for(var i = 0; i < seleccionados.length; i++){
      pedidos += "*[" + seleccionados[i].nombre + "]* " + "\$" + seleccionados[i].precio.toString() + " x" + seleccionados[i].cantidad.toString() + "\n";
      total += seleccionados[i].precio * seleccionados[i].cantidad;
    }
    if(pedidos != "") {
      pedidos += "---------------------------------";
      pedidos += "\n*Valor a Pagar:* \$" + total.toString();
    }
    return "\n" + pedidos;
  } */

  @override
  Widget build(BuildContext context) {
    //barProv = Provider.of<BarProvider>(context);
    //bar_id = ModalRoute.of(context).settings.arguments.toString();
    bar = ModalRoute.of(context).settings.arguments;
    //bar = BarCtrl.barPorId(bar.id.toString());
    productos = ProductoCtrl.menuDiarioBar(bar.id.toString());
    pedidoProv = Provider.of<PedidoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(bar.nombre)
      ),
      //drawer: LeftNav().getLeftMenu2(context, usuario),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,), 
        onPressed: (){
          FlutterOpenWhatsapp.sendSingleMessage("593"+bar.celular, "Hola, quisiera realizar un pedido ...");                          
      }), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Menú",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  )
                )
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child:  FutureBuilder<List<MenuDiario>>(
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
                                  pedidoProv.addSeleccionadoMenuDiario(bar.id, snapshot.data[index]);
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
                  return SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
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
                                  title: Text(pedidoProv.getPedido(bar.id)[index].nombre),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.remove_shopping_cart,
                                      color: Colors.red,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        //removeSeleccionado(seleccionados[index].id);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: (){
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
                    'Enviar Pedido', 
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
      ),
    );
  }
}
