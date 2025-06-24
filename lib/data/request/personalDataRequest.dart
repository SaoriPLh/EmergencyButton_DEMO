class Personaldatarequest {
  final String NombreCompleto;
  final String TipoDeSangre;
  final String Direccion;

  Personaldatarequest({
    required this.NombreCompleto,
    required this.TipoDeSangre,
    required this.Direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      'NombreCompleto': NombreCompleto,
      'TipoDeSangre': TipoDeSangre,
       'Direccion': Direccion,
    };
  }
}
