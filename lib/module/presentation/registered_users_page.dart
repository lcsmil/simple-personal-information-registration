import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_personal_information_registration/module/entitie/user.dart';
import 'package:simple_personal_information_registration/module/presentation/user_registration_page.dart';

class RegisteredUsersPage extends StatefulWidget {
  @override
  _RegisteredUsersPageState createState() => _RegisteredUsersPageState();
}

class _RegisteredUsersPageState extends State<RegisteredUsersPage> {
  List<User> _users;

  @override
  void initState() {
    super.initState();
    _users = [];
    _loadUsers();
  }

  Future<Null> _loadUsers() async {
    final String usersFetched = await getListData('user');
    if (usersFetched != null) {
      final List<User> users = User.decode(usersFetched);
      setState(() {
        _users = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Registros"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) => SizedBox(height: 30),
          itemCount: _users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => _showDialog(context, _users[index]),
              child: Card(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Nome: ${_users[index].name}'),
                      SizedBox(height: 10),
                      Text('Idade: ${_users[index].age}')
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserRegistrationPage()),
          );
        },
      ),
    );
  }
}

Future<String> getListData(String key) async {
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  return myPrefs.getString(key);
}

Future<void> _showDialog(BuildContext context, User user) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('O que deseja fazer?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Editar'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserRegistrationPage(userData: user),
                ),
              );
            },
          ),
          TextButton(
            child: const Text('Remover'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
