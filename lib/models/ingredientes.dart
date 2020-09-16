class Ingredientes{
  int idproducto;
  int idcomponente;
  String producto;
  String componente;

  Ingredientes({this.idcomponente, this.componente, this.producto, this.idproducto});

  factory Ingredientes.fromJson(Map<String, dynamic> json) {
    return Ingredientes(
      idproducto: json['id_producto'],
      idcomponente: json['id_componente'],
      producto: json['producto'],
      componente: json['componente']
    );
  }
}