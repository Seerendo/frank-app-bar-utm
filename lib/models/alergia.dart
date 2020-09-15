class Alergia{
  int id;
  String nombre;

  Alergia({this.id, this.nombre});

  factory Alergia.fromJson(Map<String, dynamic> json) {
    return Alergia(
      id: json['id'],
      nombre: json['nombre']
    );
  }

  factory Alergia.fromUsuarioAlergiasJson(Map<String, dynamic> json) {
    return Alergia(
      id: json['id_alergia'],
      nombre: json['nombre']
    );
  }
}