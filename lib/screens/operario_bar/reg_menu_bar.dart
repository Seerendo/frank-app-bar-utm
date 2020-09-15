import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/models/bar.dart';
import 'package:cfhc/models/menu_diario.dart';
import 'package:cfhc/models/producto_bar.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegMenuBar extends StatefulWidget {
  RegMenuBar() : super();

  @override
  _RegMenuBarState createState() => _RegMenuBarState();
}

class _RegMenuBarState extends State<RegMenuBar> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    String id_usuario = ModalRoute.of(context).settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Diario'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Bar bar;
  Map dropDownItemsMap;
  Future<List<ProductoBar>> productos;
  ProductoBar _selectedItem;
  List<DropdownMenuItem> list = List<DropdownMenuItem>();
  Future<List<MenuDiario>> productosMenu;
  Future<List<MenuDiario>> productosMenuDiaAnterior;
  //List<MenuDiario> productosDiaAnterior;
  GlobalKey _keyLoader = new GlobalKey();

  @override
  void initState() {
    super.initState();  
  }

  @override
  Widget build(BuildContext context) {
    bar = Provider.of<BarProvider>(context).getBar();
    productos = ProductoCtrl.listarProductosBar(bar.id.toString());
    productosMenu = ProductoCtrl.menuDiarioBar(bar.id.toString());
    productosMenuDiaAnterior = ProductoCtrl.menuDiarioBarDiaAnterior(bar.id.toString());

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.fastfood, size: 36,),
              SizedBox(width: 10),
              Expanded(
                child: FutureBuilder<List<ProductoBar>>(
                  future: productos,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      list.clear();
                      dropDownItemsMap = new Map();

                      snapshot.data.forEach((producto) {
                        int index = producto.id;
                        dropDownItemsMap[index] = producto;

                        list.add(new DropdownMenuItem(
                          child: Text("\$"+producto.precio.toString() + " " +producto.nombre),
                          value: producto.id));
                      });

                      return Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: list,
                            onChanged: (selected) {
                              print(selected);
                              print(dropDownItemsMap[selected]);
                              _selectedItem = dropDownItemsMap[selected];
                              setState(() {
                                _selectedItem = dropDownItemsMap[selected];
                              });
                            },
                            hint: new Text(
                              _selectedItem != null ? "\$"+_selectedItem.precio.toString() + " " +_selectedItem.nombre: "No Seleccionado",
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
              IconButton(
                icon: Icon(Icons.add_circle,size: 40,color: Colors.green,),
                onPressed: (){
                  if(_selectedItem == null) {
                    Dialogs.mostrarDialog(context, "Advertencia", "Debes Seleccionar un producto"); 
                    return;
                  }
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");    
                    //ProductoCtrl.insertProductoMenu(bar.id.toString(),_selectedItem.id.toString(),_precio).then((value){
                    ProductoCtrl.insertProductoMenu(bar.id.toString(),_selectedItem.id.toString(),_selectedItem.precio).then((value){
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      if(value == true){
                        setState(() {
                          productosMenu = ProductoCtrl.menuDiarioBar(bar.id.toString());
                          Dialogs.mostrarDialog(context, "Éxito", "Producto Agregado Correctamente"); 
                        });
                      }else {
                        Dialogs.mostrarDialog(context, "Error", "Error al agregar"); 
                      }
                    });
                  }
                },
              ),
            ]
          ),
          SizedBox(height: 10),
          FutureBuilder<List<MenuDiario>>(
            future: productosMenuDiaAnterior,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Container();
              }
              if (snapshot.hasData) {
                if(snapshot.data.length == 0){
                  return Container();
                }
                return Row(
                  children: <Widget>[
                    new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: (){
                        copiarMenu(snapshot.data);
                      },
                      padding: EdgeInsets.all(12),
                      color: Colors.orangeAccent,
                      child: Text(
                        'Copiar menú de Ayer', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ), 
                    Text("")
                  ],
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
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 600.0,
              child: FutureBuilder<List<MenuDiario>>(
                future: productosMenu,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    if(snapshot.data.length == 0){
                      return Text("No existen Productos Registrados");
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data);
                        if(snapshot.data.length == 0){
                          return Container();
                        }
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].nombre + " ,  \$ " + snapshot.data[index].precio.toString()),
                            trailing: new IconButton(
                              icon: new Icon(Icons.clear,color: Colors.red,),
                              onPressed: () {
                                Dialogs.mostrarLoadingDialog(context,_keyLoader, "Eliminando");
                                ProductoCtrl.deleteProductoMenu(snapshot.data[index].id.toString()).then((value){
                                  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                                  if(value == true){                     
                                    setState(() {
                                      productosMenu = ProductoCtrl.menuDiarioBar(bar.id.toString());
                                    });
                                    Dialogs.mostrarDialog(context, "Éxito", "Producto Eliminado Correctamente"); 
                                  }else {
                                    Dialogs.mostrarDialog(context, "Error", "Error al eliminar");
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
        ]
      ),
    );
  }

  void copiarMenu(List<MenuDiario> prod) {
    List<Future<bool>> futurprods = List<Future<bool>>();
    for (var i = 0; i < prod.length; i++) {
      futurprods.add(
        ProductoCtrl.insertProductoMenu(prod[i].id_bar.toString(),prod[i].id_producto.toString(),prod[i].precio)
      );
    }
    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Copiando Productos");
    Future.wait(futurprods)
      .then((List<bool> nums) {
        bool bandera = true;
        for (var i = 0; i < nums.length; i++) {
          if(!nums[i]){bandera = false;}          
        }
        if(bandera){
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          Dialogs.mostrarDialog(context,"Éxito","Se copiaron los productos con éxito");
        }else{
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          Dialogs.mostrarDialog(context,"Error","Error al copias todos los productos");
        }
      });
    
  }

}