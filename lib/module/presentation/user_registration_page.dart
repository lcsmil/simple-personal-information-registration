import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_personal_information_registration/module/entitie/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class UserRegistrationPage extends StatefulWidget {
  UserRegistrationPage({this.userData});

  final User userData;

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  var _genderTypes = ['Masculino', 'Feminino', 'Indiferente'];
  String _selectedItem;
  Map<String, String> _registrationObject = Map<String, String>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: _autovalidate,
            key: _key,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  _buildNameField,
                  SizedBox(height: 30),
                  _buildAgeField,
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Sexo'),
                  ),
                  _buildGenderField,
                  SizedBox(height: 50),
                  TextButton(
                    child: Text('Adicionar'),
                    onPressed: _doRegister,
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => _showDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildNameField {
    return TextFormField(
      decoration: InputDecoration(labelText: "Nome"),
      onSaved: (String val) => _registrationObject['name'] = val,
      maxLength: 70,
      validator: (String value) {
        if (value == null) {
          return "O campo não pode estar vazio";
        } else {
          return null;
        }
      },
    );
  }

  Widget get _buildAgeField {
    final format = DateFormat("dd/MM/yyyy");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data de Nascimento'),
        DateTimeField(
          format: format,
          validator: (DateTime value) {
            if (value == null) {
              return "O campo não pode estar vazio";
            } else {
              return null;
            }
          },
          onSaved: (DateTime val) {
            _registrationObject['birthday'] = calculateAge(val).toString();
          },
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ),
      ],
    );
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget get _buildGenderField {
    return DropdownButtonFormField(
      value: _selectedItem,
      hint: Text(
        'Selecione',
      ),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
        });
      },
      onSaved: (String val) => _registrationObject['gender'] = val,
      validator: (String value) {
        if (value == null) {
          return "O campo não pode estar vazio";
        } else {
          return null;
        }
      },
      items: _genderTypes.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
          ),
        );
      }).toList(),
    );
  }

  void _doRegister() {
    setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _writeData();
      Navigator.pop(context);
    }
  }

  void _writeData() async {
    List<User> user = [
      User(
        name: _registrationObject['name'],
        age: _registrationObject['birthday'],
        gender: _registrationObject['gender'],
      )
    ];

    final String encodedData = User.encode(user);
    setListData('user', encodedData);
  }
}

setListData(String key, String value) async {
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  myPrefs.setString(key, value);
}

Future<void> _showDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cancelar'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Deseja realmente cancelar o cadastro?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Sim'),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          TextButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
