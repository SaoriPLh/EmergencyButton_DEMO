

import 'package:emergency_button/data/models/personalDataModel.dart';
import 'package:emergency_button/data/repositoris/personalData_repo.dart';
import 'package:emergency_button/data/request/personalDataRequest.dart';

class PersonalDataService {
  final PersonaldataRepo personaldataRepo;

  PersonalDataService({required this.personaldataRepo});

  Future<PersonalDataModel> save(Personaldatarequest data) async {
    return await personaldataRepo.savePersonalData(data);
  }

  Future<PersonalDataModel> delete(Personaldatarequest data) async {
    return await personaldataRepo.deletePersonalData(data);
  }

  Future<PersonalDataModel> load() async {
    return await personaldataRepo.loadPersonalData();
  }

  Future<bool> clear() async {
    return await personaldataRepo.clearPersonalData();
  }
}
