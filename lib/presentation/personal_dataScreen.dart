import 'package:emergency_button/data/repositoris/personalData_repo.dart';
import 'package:emergency_button/data/services/personalDataService.dart';
import 'package:emergency_button/presentation/HomeScrenButton.dart';
import 'package:flutter/material.dart';
import 'package:emergency_button/data/http/apiService.dart';
import 'package:emergency_button/data/http/httpClient.dart';
import 'package:emergency_button/data/request/personalDataRequest.dart';


class PersonalDataForm extends StatefulWidget {
  @override
  _PersonalDataFormState createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final _formKey = GlobalKey<FormState>();
final List<String> _tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
String? _sangreSeleccionada;
  final _nombreController = TextEditingController();
  final _sangreController = TextEditingController();
  final _direccionController = TextEditingController();

  late PersonalDataService personalDataService;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(httpClient: HttpclientService());
    final repo = PersonaldataRepo(apiService: apiService);
    personalDataService = PersonalDataService(personaldataRepo: repo);

    _loadPersonalData();
  }

  void _loadPersonalData() async {
    try {
      final data = await personalDataService.load();
      _nombreController.text = data.NombreCompleto;
      _sangreController.text = data.TipoDeSangre;
      _direccionController.text = data.Direccion;
      
    } catch (_) {
      // puede que no haya datos aún
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = Personaldatarequest(
        NombreCompleto: _nombreController.text,
        TipoDeSangre: _sangreSeleccionada ?? '',
        Direccion : _direccionController.text 
        
      );

      await personalDataService.save(request);
      _loadPersonalData();
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Homescrenbutton(
          _nombreController.text,
          _direccionController.text,
        ),
      ),
    );
    }
  }

  void _clearData() async {
    await personalDataService.clear();
    _loadPersonalData();
    _formKey.currentState?.reset();
  }

 Widget _buildField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        prefixIcon: Icon(Icons.edit, size: 20),
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Campo requerido' : null,
    ),
  );
}

  @override
  void dispose() {
    _nombreController.dispose();
    _sangreController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Datos Personales")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Nombre completo", _nombreController),
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 10),
  child: DropdownButtonFormField<String>(
    value: _sangreSeleccionada,
    decoration: InputDecoration(
      labelText: "Tipo de sangre",
      labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
      filled: true,
      fillColor: Colors.grey[100],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      prefixIcon: Icon(Icons.bloodtype),
    ),
    items: _tiposSangre.map((tipo) {
      return DropdownMenuItem(
        value: tipo,
        child: Text(tipo),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _sangreSeleccionada = value;
        _sangreController.text = value ?? '';
      });
    },
    validator: (value) =>
        value == null || value.isEmpty ? 'Selecciona un tipo de sangre' : null,
  ),
),
              _buildField("Direccion", _direccionController),
              SizedBox(height: 20),
             ElevatedButton(
  onPressed: _submit,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  ),
  child: Text(
    "Guardar datos",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
),
SizedBox(height: 10),
ElevatedButton(
  onPressed: _clearData,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  ),
  child: Text(
    "Eliminar datos",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
