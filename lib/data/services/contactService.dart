import 'package:emergency_button/data/models/Contact_model.dart';
import 'package:emergency_button/data/repositoris/contact_repo.dart';
import 'package:emergency_button/data/request/addContactRequest.dart';

class ContactService {
  final ContactRepo contactRepo;

  ContactService({required this.contactRepo});

  Future<List<ContactModel>> saveContact(Addcontactrequest data) async {
    return await contactRepo.saveContact(data);
  }

  Future<List<ContactModel>> loadContacts() async {
    return await contactRepo.loadContacts();
  }

  Future<List<ContactModel>> deletePhoneNumber(String nombre,String number) async {
    return await contactRepo.deletePhoneNumber(nombre,number);
  }
}
