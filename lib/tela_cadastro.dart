import 'package:flutter/material.dart';
import 'mongo_service.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _acceptedTerms = false; // Variável para controlar a checkbox

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_acceptedTerms) {
        await MongoService.registerUser(_name, _email, _password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário registrado com sucesso')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Você deve aceitar os termos de serviço para se registrar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome completo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Eu aceito os termos de serviço'),
                value: _acceptedTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
