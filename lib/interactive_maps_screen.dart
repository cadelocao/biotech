import 'package:flutter/material.dart';

class InteractiveMapsScreen extends StatelessWidget {
 final Map<String, dynamic> user;

  InteractiveMapsScreen({required this.user});
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapas Interativos'),
      ),
      body: InteractiveMapsBody(),
    );
  }
}

class InteractiveMapsBody extends StatefulWidget {
  @override
  _InteractiveMapsBodyState createState() => _InteractiveMapsBodyState();
}

class _InteractiveMapsBodyState extends State<InteractiveMapsBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.lightBlue[50],
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                'Mapa Interativo',
                style: TextStyle(fontSize: 24, color: Colors.black54),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 100,
            child: Icon(
              Icons.place,
              size: 40,
              color: Colors.red,
            ),
          ),
          Positioned(
            top: 200,
            left: 150,
            child: Icon(
              Icons.place,
              size: 40,
              color: Colors.green,
            ),
          ),
          Positioned(
            top: 300,
            left: 50,
            child: Icon(
              Icons.place,
              size: 40,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
