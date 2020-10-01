import 'package:cfhc/models/tipos_usuario.dart';
import 'package:cfhc/partials/dialogs.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';

class RegistroUsuario extends StatefulWidget {
  RegistroUsuario() : super();

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Usuario usuario = null;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 8.0),
          child: RegisterForm(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
  bool _agreedToTOS = true;
  Usuario _usuario = Usuario();
  Future<List<TipoUsuario>> tiposUsuario;
  
  UsuarioProvider authProv;

  String password = '';
  String password2 = '';
  
  bool _obscureText = false;  
  bool _obscureText2 = false;  

  Map dropDownItemsMap;
  TipoUsuario _selectedItem;
  List<DropdownMenuItem> list = List<DropdownMenuItem>();

  @override
  Widget build(BuildContext context) {
    authProv = Provider.of<UsuarioProvider>(context);   
    tiposUsuario = authProv.listarTiposUsuario();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text("Tipo de Usuario: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                ),
              ),
              FutureBuilder<List<TipoUsuario>>(
                future: tiposUsuario,
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
                        child: Text(producto.nombre),
                        value: producto.id));
                    });

                    return Expanded(                      
                      child:DropdownButton(
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
                          _selectedItem != null ? _selectedItem.nombre: "No Seleccionado",
                        ),
                      )
                    );
                  } else {
                    return SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ), 
            ],
          ),
          SizedBox(height: 5,),
          TextFormField(
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Apellidos',
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
              if (value.length > 40) {
                return 'No se pueden ingresar más de 40 caracteres';
              }
            },
            onSaved: (value){
              setState(() {
                _usuario.apellidos = value;
              });
            },
          ),
          SizedBox(height: 10,),
          TextFormField(
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Nombres',
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'No ha ingresado este campo';
              }
              if (value.length > 40) {
                return 'No se pueden ingresar más de 40 caracteres';
              }
            },
            onSaved: (value){
              setState(() {
                _usuario.nombre = value;
              });
            },
          ),
          SizedBox(height: 40,),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Correo',
              prefixIcon: Icon(Icons.mail),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            ),
            validator: FormValidator().validateEmail,
            onSaved: (value){
              setState(() {
                _usuario.correo = value;
              });
            },
          ),
          
          const SizedBox(height: 10.0),         
          TextFormField(   
            style: TextStyle(fontSize: 18),
            obscureText: !_obscureText,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    _obscureText = !_obscureText2;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText ? 'Mostrar Contraseña' : 'Ocultar Contraseña',
                ),
              )
            ),
            validator: FormValidator().validatePassword,
            onSaved: (value){
              password = value.trimLeft().trimRight();
            },
          ),
          const SizedBox(height: 10.0), 
          TextFormField(   
            style: TextStyle(fontSize: 18), 
            obscureText: !_obscureText2,
            decoration: InputDecoration(
              labelText: 'Repetir Contraseña',
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              //border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    _obscureText2 = !_obscureText2;
                  });
                },
                child: Icon(
                  _obscureText2 ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText2 ? 'Mostrar Contraseña' : 'Ocultar Contraseña',
                ),
              )
            ),
            validator: FormValidator().validatePassword,
            onSaved: (value){
              password2 = value.trimLeft().trimRight();
            },
          ),  
          const SizedBox(height: 20.0),
          /* Row(
            children: <Widget>[
              Checkbox(
                value: _agreedToTOS,
                onChanged: _setAgreedToTOS,
              ),
              GestureDetector(
                onTap: () => _setAgreedToTOS(!_agreedToTOS),
                child: Container(                  
                  width: 280,
                  child: const Text(
                    'Estoy de Acuerdo con las Políticas de Privacidad',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                  ),
                ),                
              ),
            ],
          ),     */   
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //const Spacer(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                //onPressed: _submittable() ? _submit : null,
                onPressed: _submit,
                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                color: Colors.green,
                child: Text(
                  'Registrar', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    if (_formKey.currentState.validate()){
      _usuario.id_tipo_usuario = 1;
      _formKey.currentState.save();
      if(password != password2){
        Dialogs.mostrarDialog(context, "Advertencia", "Las Contraseñas no coinciden");
        return;
      }
      if(_selectedItem == null){
        Dialogs.mostrarDialog(context, "Advertencia", "Elija un Tipo de Usuario");
        return;
      }
      _usuario.pass = password;    
      postUsuario();      
    }    
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  void postUsuario() {
    Dialogs.mostrarLoadingDialog(context,_keyLoader, "Registrando");
    if (_formKey.currentState.validate()){
      _usuario.id_tipo_usuario = _selectedItem.id;
      _formKey.currentState.save();
      authProv.registrarUsuario(_usuario).then((value) {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        print(value);
        if (value == 1) {
          Navigator.of(context).pushReplacementNamed('/login');
          Dialogs.mostrarDialog(context, "Información", "Usuario Registrado con Éxito");
        } else if (value == 2) {
          Dialogs.mostrarDialog(context, "Error", "Ya existe un usuario registrado con el correo especificado");
        }else {
          Dialogs.mostrarDialog(context, "Error","Error al registrar el usuario");
        } 
      });
    }
  }
}