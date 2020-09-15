import 'package:flutter/material.dart';

class Dialogs {  
  static void mostrarLoadingDialog(BuildContext context,GlobalKey key, String mensaje) {
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          key: key,
          backgroundColor: Colors.white,
          children: <Widget>[
            Center(
              child: Column(children: [
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                SizedBox(height: 10,),
                Text(mensaje, style: TextStyle(fontSize: 20),)
              ]),
            )
          ]));
    });
  }

  static void mostrarDialog(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(titulo),
          content: new Text(mensaje),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}