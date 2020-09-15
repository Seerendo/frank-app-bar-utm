import 'package:cfhc/models/usuario.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/componentes_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:cfhc/providers/producto_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeftNav {
  static LeftNav _instance;
 
  factory LeftNav() => _instance ??= new LeftNav._();
 
  LeftNav._();

  Widget getLeftMenu2( BuildContext context/* , Usuario usuario */){    
    UsuarioProvider authProv = Provider.of<UsuarioProvider>(context);
    EncuestaProvider encuestaProv = Provider.of<EncuestaProvider>(context);
    ComponenteProvider componentProv = Provider.of<ComponenteProvider>(context);
    ProductoProvider productoProv = Provider.of<ProductoProvider>(context);
    Usuario usuario = authProv.getUsuario();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(usuario!=null?usuario.nombre:"Usuario",style: TextStyle(fontSize: 20),),
            accountEmail: Text(usuario!=null?usuario.correo:"usuario@correo.com"),
            /* currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(usuario!=null?'${usuario.nombre[0]}':"U",style: TextStyle(fontSize: 40.0) )
            ) */
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Lista Locales'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/lista_bares');
              /* Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/lista_bares",
                (route) => route.isCurrent && route.settings.name == "/lista_bares"
                  ? false
                  : true,
                ); */
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Admin Alergias'),
            onTap: () {
              encuestaProv.listarAlergias();
              Navigator.of(context).pushReplacementNamed('/alergias_admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Admin Enfermedades'),
            onTap: () {
              encuestaProv.listarEnfermedades();
              Navigator.of(context).pushReplacementNamed('/enfermedades_admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Admin Categorias Alimento'),
            onTap: () {
              encuestaProv.listarCategoriasAlimento();
              Navigator.of(context).pushReplacementNamed('/categorias_alimento_admin');
            },
          ),
           ListTile(
            leading: Icon(Icons.store),
            title: Text('Admin Componentes'),
            onTap: () {
              componentProv.listarComponentes();
              Navigator.of(context).pushReplacementNamed('/registrar_componentes');
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Admin Ingredientes'),
            onTap: () {
              componentProv.listarComponentes();
              productoProv.listarProductos();
              Navigator.of(context).pushReplacementNamed('/registrar_ingredientes');
            },
          ),
          if (usuario != null && usuario.tipo == "Operario de Bar") ... [
            SizedBox(
              height: 5,
              child: CustomPaint(painter: Drawhorizontalline()),
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Mi Local'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/mi_bar');
              }
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Productos'),
              onTap: () {
                Navigator.pop(context);
                //Navigator.pushNamed(context, '/registro_producto');
                Navigator.of(context).pushNamedAndRemoveUntil(
                "/registro_producto",
                (route) => route.isCurrent && route.settings.name == "/registro_producto"
                  ? false
                  : true,
                );
              },
            ),
          ],
          SizedBox(
            height: 5,
            child: CustomPaint(painter: Drawhorizontalline()),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('Información de Cuenta'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/info_usuario');
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Realizar Encuesta'),
            onTap: () {              
              encuestaProv.listarAlergias();
              encuestaProv.listarEnfermedades();
              encuestaProv.listarEstilosVida();
              Navigator.pop(context);
              //Navigator.pushNamed(cont_usuario);
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/alergias",
                (route) => route.isCurrent && route.settings.name == "/alergias"
                  ? false
                  : true,
                arguments: usuario.id_usuario
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión'),
            onTap: () {
              authProv.deleteUsuario();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              //Navigator.of(context).pushReplacementNamed('/login');            
            },
          ),
        ]
      ),
    );    
  }

}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(4.0, 0.0), Offset(300.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}