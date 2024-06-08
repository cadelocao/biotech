import 'package:flutter/material.dart';
import 'mongo_service.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  SettingsScreen({required this.user});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await MongoService.changePassword(
        widget.user['id'],
        _currentPassword,
        _newPassword,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Senha alterada com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao alterar a senha')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha Atual'),
                obscureText: true,
                onSaved: (value) => _currentPassword = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
                onSaved: (value) => _newPassword = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Alterar Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

