import 'package:flutter/material.dart';
import 'mongo_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  ChangePasswordScreen({required this.user});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';

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
          SnackBar(content: Text('Senha alterada com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao alterar a senha.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha Atual',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira sua senha atual';
                  }
                  return null;
                },
                onSaved: (value) {
                  _currentPassword = value ?? '';
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a nova senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newPassword = value ?? '';
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirme a Nova Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme a nova senha';
                  }
                  if (value != _newPassword) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmNewPassword = value ?? '';
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Alterar Senha'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
