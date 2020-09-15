class EstiloVida{
  int id;
  String nombre;

  EstiloVida({this.id, this.nombre});

  factory EstiloVida.fromJson(Map<String, dynamic> json) {
    return EstiloVida(
      id: json['id'],
      nombre: json['nombre']
    );
  }

  factory EstiloVida.fromUsuarioEstiloVidaJson(Map<String, dynamic> json) {
    return EstiloVida(
      id: json['id_estilo_vida'],
      nombre: json['nombre']
    );
  }
}