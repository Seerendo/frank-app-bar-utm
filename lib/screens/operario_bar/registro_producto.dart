import 'package:cfhc/controllers/producto_ctrl.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:flutter/material.dart';
import '../../models/producto.dart';

class RegistroProducto extends StatefulWidget {
  RegistroProducto() : super();

  @override
  _RegitroProductoState createState() => _RegitroProductoState();
}

class _RegitroProductoState extends State<RegistroProducto> {
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
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
  GlobalKey _keyLoader = new GlobalKey();
  Producto _producto = Producto();
  Future<List<Producto>> productos;

  @override
  Widget build(BuildContext context) {
    productos = ProductoCtrl.listarProductosCanDelete();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.fastfood),
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'No ha ingresado este campo';
                    }
                  },
                  onSaved: (value){
                    setState(() {
                      _producto.nombre = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle,size: 40,color: Colors.green,),
                tooltip: 'Registrar',
                onPressed: _submit,
              ),
            ],
          ),          
          SizedBox(height: 30), 
          SizedBox(
            height: 600,
            child: FutureBuilder<List<Producto>> ( 
              future: productos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return Text("No existen productos Registrados");
                }
                if (snapshot.hasData) {
                  if(snapshot.data.length == 0){
                    return Text("No existen productos Registrados");
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data[index].puedeBorrar);
                      if(snapshot.data[index].puedeBorrar == "si"){
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].nombre),                          
                            trailing: 
                            new IconButton(
                              icon: new Icon(Icons.clear,color: Colors.red,),
                              onPressed: () {
                                Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");    
                                ProductoCtrl.deleteProducto(snapshot.data[index].id.toString()).then((res){
                                  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                                  if(res){
                                    Dialogs.mostrarDialog(context, "Éxito", "Producto Eliminado Correctamente");
                                    setState(() {
                                      productos = ProductoCtrl.listarProductosCanDelete();
                                    });
                                  }else {
                                    Dialogs.mostrarDialog(context, "Error", "Error al agregar"); 
                                  }
                                });                                
                              }, 
                            ),
                          ),
                        );
                      }
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].nombre),
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
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();

      ProductoCtrl.insertProducto(_producto).then((res){
        if(res){
          setState(() {
            _producto.nombre = '';
          });
          Dialogs.mostrarDialog(context, "Éxito", "Producto Registrado Correctamente");
          productos = ProductoCtrl.listarProductosCanDelete();
        }else {
          Dialogs.mostrarDialog(context, "Error", "Error al registrar"); 
        }
      });
    }    
  }
  
}