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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel')
      ),
      drawer: LeftNav().getLeftMenu2(context/* , usuario */),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[            
            
          ]
        ),
      ),
    );
  }
}
