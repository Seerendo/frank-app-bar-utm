import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/providers/bar_provider.dart';
import 'package:cfhc/providers/componentes_provider.dart';
import 'package:cfhc/providers/encuesta_provider.dart';
import 'package:cfhc/providers/ingredientes_provider.dart';
import 'package:cfhc/providers/pedido_provider.dart';
import 'package:cfhc/providers/producto_provider.dart';
import 'package:cfhc/screens/admin/alergias_admin.dart';
import 'package:cfhc/screens/admin/categorias_alimentos_admin.dart';
import 'package:cfhc/screens/admin/componentes_admin.dart';
import 'package:cfhc/screens/admin/enfermedades_admin.dart';
import 'package:cfhc/screens/admin/ingredientes_admin.dart';

import 'package:cfhc/screens/encuesta/alergias.dart';
import 'package:cfhc/screens/encuesta/enfermedades.dart';
import 'package:cfhc/screens/encuesta/estilos_vida.dart';
import 'package:cfhc/screens/encuesta/preferencias.dart';
import 'package:cfhc/screens/encuesta/actividades_cuarentena.dart';
import 'package:cfhc/screens/encuesta/alimentos_cuarentena.dart';
import 'package:cfhc/screens/root_page.dart';

import 'package:cfhc/screens/user/change_password.dart';
import 'package:cfhc/screens/operario_bar/edit_bar.dart';
import 'package:cfhc/screens/user/edit_usuario.dart';
import 'package:cfhc/screens/user/info_usuario.dart';
import 'package:cfhc/screens/bares/menu_bar.dart';
import 'package:cfhc/screens/operario_bar/mi_bar.dart';
import 'package:cfhc/screens/operario_bar/productos_bar.dart';
import 'package:cfhc/screens/operario_bar/reg_menu_bar.dart';
import 'package:cfhc/screens/principal_objects/registro_alergia.dart';
import 'package:cfhc/screens/operario_bar/registro_bar.dart';
import 'package:cfhc/screens/principal_objects/registro_enfermedad.dart';
import 'package:cfhc/screens/principal_objects/registro_estilo_vida.dart';
import 'package:cfhc/screens/operario_bar/registro_producto.dart';
import 'package:cfhc/screens/registro_usuario.dart';
import 'package:cfhc/screens/bares/vista_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/bares/lista_bares.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsuarioProvider>(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider<BarProvider>(create: (context) => BarProvider()),        
        ChangeNotifierProvider<PedidoProvider>(create: (context) => PedidoProvider()),
        ChangeNotifierProvider<EncuestaProvider>(create: (context) => EncuestaProvider()),
        ChangeNotifierProvider<ComponenteProvider>(create: (context) => ComponenteProvider()),
        ChangeNotifierProvider<ProductoProvider>(create: (context) => ProductoProvider()),
        ChangeNotifierProvider<IngredientesProvider>(create: (context) => IngredientesProvider()),
        //StreamProvider<ConnectivityStatus>(create: (context) => ConnectivityService().connectionStatusController)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cognitive Self Care',
        theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.redAccent
        ),
        //home: Login(),
        //6initialRoute: '/',
        routes: {
          '/actividades_cuarentena' : (context) => ActividadesCuarentena(),
          '/alimentos_cuarentena' : (context) => AlimentosCuarentena(),
          '/alergias' : (context) => Alergias(),
          '/enfermedades' : (context) => Enfermedades(),        
          '/preferencias' : (context) => Preferencias(),
          '/estilos_vida' : (context) => EstilosVida(),


          '/alergias_admin' : (context) => AlergiasAdmin(),
          '/categorias_alimento_admin' : (context) => CategoriasAlimentosAdmin(),
          '/enfermedades_admin' : (context) => EnfermedadesAdmin(),

          '/' : (context) => RootPage(),
          '/login' : (context) => Login(),
          '/registrar_usuario' : (context) => RegistroUsuario(),
          '/info_usuario' : (context) => InfoUsuario(),
          '/editar_usuario' : (context) => EditUsuario(),
          '/cambiar_pass' : (context) => ChangePass(),

          '/registro_alergia' : (context) => RegistroAlergia(),
          '/registro_enfermedad' : (context) => RegistroEnfermedad(),
          '/registro_estilo_vida' : (context) => RegistroEstiloVida(),
          
          '/lista_bares' : (context) => ListaBares(),

          '/mi_bar' : (context) => MiBar(),
          '/registrar_bar' : (context) => RegistroBar(),
          '/edit_bar' : (context) => EditarBar(),
          '/productos_bar' : (context) => ProductosBar(),
          '/info_bar' : (context) => VistaBar(),
          '/reg_menu_diario' : (context) => RegMenuBar(),
          '/menu_diario' : (context) => MenuDiarioBar(),

          '/registro_producto' : (context) => RegistroProducto(),
          '/registro_categoria_alimento' : (context) => ProductosBar(),

          '/registrar_componentes' : (context) => ComponentesAdmin(),
          '/registrar_ingredientes' : (context) => IngredientesAdmin()
        }, 
      ),
    );
  }
}
