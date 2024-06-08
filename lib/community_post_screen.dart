import 'package:flutter/material.dart';
import 'mongo_service.dart';

class CommunityPostScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  CommunityPostScreen({required this.user});

  @override
  _CommunityPostScreenState createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final post = {
        'title': _title,
        'content': _content,
        'date': DateTime.now().toIso8601String(),
        'userName': widget.user['name'],
        'userProfilePicture': widget.user['profilePicture'],
      };
      await MongoService.addCommunityPost(post);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) => value!.isEmpty ? 'Please enter content' : null,
                onSaved: (value) => _content = value!,
                maxLines: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePost,
                child: Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
