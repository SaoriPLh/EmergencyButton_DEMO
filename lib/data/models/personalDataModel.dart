class PersonalDataModel {
  final String NombreCompleto;
  final String TipoDeSangre;
  final String Direccion;

  PersonalDataModel({
    required this.NombreCompleto,
    required this.TipoDeSangre,
    required this.Direccion,
  });

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      NombreCompleto: json['NombreCompleto'] ?? '',
      TipoDeSangre: json['TipoDeSangre'] ?? '',
      Direccion: json['Direccion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NombreCompleto': NombreCompleto,
      'TipoDeSangre': TipoDeSangre,
      'Direccion': Direccion,
    };
  }
}
