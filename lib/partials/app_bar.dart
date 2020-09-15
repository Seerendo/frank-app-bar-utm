import 'package:flutter/material.dart';

class MainAppBar {
  static MainAppBar _instance;
 
  factory MainAppBar() => _instance ??= new MainAppBar._();
 
  MainAppBar._();

  Widget getAppBar( BuildContext context){
    return AppBar(
      title: Text('Recomendados para Tí'),
      /*bottom: TabBar(tabs: [
        Tab(
          icon: Icon(Icons.fastfood)            
        ),
        Tab(icon: Icon(Icons.star_half)
        ),
        Tab(icon: Icon(Icons.format_list_numbered)
        ),
        Tab(icon: Icon(Icons.location_on)
        ),
      ],
      controller: TabController(length: 4, vsync: this),
      ),*/
    );
  } 
}
