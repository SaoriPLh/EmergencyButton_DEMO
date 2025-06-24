import 'package:emergency_button/data/http/apiService.dart';
import 'package:emergency_button/data/models/personalDataModel.dart';
import 'package:emergency_button/data/request/personalDataRequest.dart';

class PersonaldataRepo {
  final ApiService apiService;

  PersonaldataRepo({required this.apiService});

  // Guardar datos personales
  Future<PersonalDataModel> savePersonalData(Personaldatarequest data) async {
    final json = await apiService.post("/savePersonalData", data.toJson());
    if (json is List && json.isNotEmpty) {
    final firstItem = json[0]; // tomar el primer objeto
    return PersonalDataModel.fromJson(firstItem);
  } else {
    throw Exception("No se encontraron datos personales");
  }
  }

  // Borrar datos personales
  Future<PersonalDataModel> deletePersonalData(Personaldatarequest data) async {
    final json = await apiService.post("/clearPersonalData", data.toJson());
    return PersonalDataModel.fromJson(json[0]);
  }

 Future<PersonalDataModel> loadPersonalData() async {
  final response = await apiService.get("/getPersonalData");

  // Validar que sea lista
  if (response is List && response.isNotEmpty) {
    final firstItem = response[0]; // tomar el primer objeto
    return PersonalDataModel.fromJson(firstItem);
  } else {
    throw Exception("No se encontraron datos personales");
  }
}



  Future<bool> clearPersonalData() async {
  final response = await apiService.post("/clearPersonalData", {}); // cuerpo vacío

  if (response is List && response.isEmpty) {
    return true; // borrado exitoso
  } else {
    throw Exception("Error al borrar los datos personales");
  }
}

}
