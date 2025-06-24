import 'package:emergency_button/data/repositoris/contact_repo.dart';
import 'package:emergency_button/data/services/contactService.dart';
import 'package:flutter/material.dart';
import 'package:emergency_button/data/request/addContactRequest.dart';
import 'package:emergency_button/data/models/Contact_model.dart';
import 'package:emergency_button/data/http/apiService.dart';
import 'package:emergency_button/data/http/httpClient.dart';

class AddContactscreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactscreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameContactController = TextEditingController();
  final _numberContactController = TextEditingController();

  late ContactService contactService;
  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(httpClient: HttpclientService());
    final contactRepo = ContactRepo(apiService: apiService);
    contactService = ContactService(contactRepo: contactRepo);
    _loadContacts();
  }

  void _loadContacts() async {
    final loadedContacts = await contactService.loadContacts();
    setState(() {
      contacts = loadedContacts;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = Addcontactrequest(
        nombre: _nameContactController.text,
        numero: _numberContactController.text,
      );

      await contactService.saveContact(request);

      _nameContactController.clear();
      _numberContactController.clear();
      _loadContacts();
    }
  }

  void _deleteContact(String nombre,String numero) async {
    await contactService.deletePhoneNumber(nombre,numero);
    _loadContacts();
  }

  @override
  void dispose() {
    _nameContactController.dispose();
    _numberContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contactos de emergencia")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                 TextFormField(
  controller: _nameContactController,
  decoration: InputDecoration(
    labelText: 'Nombre de contacto',
    labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
  validator: (value) =>
      value == null || value.isEmpty ? 'Campo requerido' : null,
),
SizedBox(height: 16),
TextFormField(
  controller: _numberContactController,
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: 'Número de contacto',
    labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
  validator: (value) =>
      value == null || value.isEmpty ? 'Campo requerido' : null,
),
                  SizedBox(height: 16),
ElevatedButton.icon(
  onPressed: _submit,
  icon: Icon(Icons.save, size: 20, color: Colors.white),
  label: Text(
    "Guardar contacto",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 139, 164, 187), // Azul elegante
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 2,
  ),
),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    child: ListTile(
                    
                      title: Text(contact.nombre),
                      subtitle: Text(contact.numeroDeContacto),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteContact(contact.nombre,contact.numeroDeContacto),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
