import 'package:cfhc/controllers/bar_ctrl.dart';
import 'package:cfhc/models/usuario.dart';
import 'package:cfhc/providers/auth_provider.dart';
import 'package:cfhc/services/conf.dart';
import 'package:provider/provider.dart';
import '../../partials/app_bar.dart';
import '../../partials/bar_row.dart';
import 'package:flutter/material.dart';
import '../../partials/left_nav.dart';
import '../../models/bar.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class ListaBares extends StatefulWidget {
  ListaBares() : super();

  @override
  _ListaBaresState createState() => _ListaBaresState();
}

List<Bar> parseBares(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Bar>((json) => Bar.fromJson(json)).toList();
}

Future<List<Bar>> fetchBares() async {
  final response = await http.get(GlobalVars.apiUrl + "bares.php");
  if (response.statusCode == 200) {
    return parseBares(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class _ListaBaresState extends State<ListaBares> {
  Future<List<Bar>> futureBar;
  Usuario usuario;

  @override
  void initState() {
    super.initState();
    //futureBar = fetchBares();
    futureBar = BarCtrl.listarBares();
  }

  @override
  Widget build(BuildContext context) {
    //usuario = ModalRoute.of(context).settings.arguments;
    usuario = Provider.of<UsuarioProvider>(context).getUsuario();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Locales'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: LeftNav().getLeftMenu2(context/* , usuario */),
      body: Center(
        child: FutureBuilder<List<Bar>>(
          future: futureBar,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Container();
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Bar bar = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/info_bar', arguments: snapshot.data[index]);
                    },
                    child: BarRow2().getBarRow(bar)
                  );
                }
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
    );
  }
}
