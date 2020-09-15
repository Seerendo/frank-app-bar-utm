import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/bar.dart';
//import 'package:flutter_tags/selectable_tags.dart';

class BarRow {
  Widget getBarRow(){
    return  Row(
      children: <Widget>[
        SizedBox(width:20),
        FlutterLogo(size: 50,),
        SizedBox(width:20),
        Column(
          children:[
            Row(
              children:<Widget>[
                Text(
                  'Nombre del Bar',
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)
                ),
                IconButton(icon: Icon(Icons.message,color:Colors.green), onPressed: null)
              ]
            ),                    
            Text("Descripción del Bar"),
            Row(
              children: <Widget>[
                Container(
                  child: Text('almuerzos'),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  child: Text('vegetariano'),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  child: Text('snacks'),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            )
          ]
        )
      ]
    );
  }

}


class BarRow2 {
  Widget getBarRow(Bar bar){
    return Card(
      child: ListTile(
        //leading: FlutterLogo(size: 50.0),
        leading: Icon(
          Icons.fastfood,
          size: 40,
          color:Colors.yellow[700]
        ),
        title: Text(
          bar.nombre,
          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)
        ),
        trailing: FaIcon(
          FontAwesomeIcons.arrowRight,
          color: Colors.redAccent[100],
          size: 30,
        ),
        /* trailing: IconButton(
          icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green,size: 30,),
          onPressed: () {
            FlutterOpenWhatsapp.sendSingleMessage("593"+bar.celular, "Hola, quisiera realizar un pedido ...");
          }                        
        ), */
        //isThreeLine: true,
      ),
    );

    /* return Row(
      children: <Widget>[
        SizedBox(width:10),
        FlutterLogo(size: 50,),
        SizedBox(width:10),
        Expanded( child: 
        Column(
          children:[
            Row(
              children:<Widget>[
                Text(
                  bar.nombre,
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)
                ),
                IconButton(
                  icon: Icon(Icons.message,color:Colors.lightBlue), 
                  onPressed: () {
                    FlutterOpenWhatsapp.sendSingleMessage("593"+bar.celular, "Hola, quisiera realizar un pedido ...");
                  }                        
                )
              ]
            ),                    
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('vegetariano'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('vegetariano'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('vegetariano'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            )
          ]
        )
        )
      ]
    ); */
  }

}