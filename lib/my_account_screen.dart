import 'package:flutter/material.dart';
import 'mongo_service.dart';

class MyAccountScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  MyAccountScreen({required this.user});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _newName = '';
  String _profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _newName = widget.user['name'];
    _profilePictureUrl = widget.user['profilePicture'];
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await MongoService.updateUserProfile(
        widget.user['id'],
        _newName,
        _profilePictureUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
      Navigator.pop(context, {
        'id': widget.user['id'],
        'name': _newName,
        'email': widget.user['email'],
        'profilePicture': _profilePictureUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _newName,
                decoration: InputDecoration(labelText: 'Nome de Exibição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de exibição';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _profilePictureUrl,
                decoration: InputDecoration(labelText: 'URL da Foto de Perfil'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da foto de perfil';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profilePictureUrl = value!;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Atualizar Perfil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
