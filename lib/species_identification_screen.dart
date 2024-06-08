import 'package:flutter/material.dart';

class SpeciesIdentificationScreen extends StatelessWidget {
    final Map<String, dynamic> user;

  SpeciesIdentificationScreen({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identificação de Espécies'),
      ),
      body: SpeciesIdentificationBody(),
    );
  }
}

class SpeciesIdentificationBody extends StatefulWidget {
  @override
  _SpeciesIdentificationBodyState createState() => _SpeciesIdentificationBodyState();
}

class _SpeciesIdentificationBodyState extends State<SpeciesIdentificationBody> {
  void _onCameraIconPressed() {
    // Lógica para abrir a câmera e identificar a espécie
    // Por exemplo, você pode usar um pacote como `image_picker` para capturar a imagem
    print('Ícone da câmera pressionado');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(Icons.camera, size: 100, color: Colors.green),
        onPressed: (){
           ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Função em desenvolvimento. Pedimos desculpas.'),
        duration: Duration(seconds: 2),
      ),
    );
        },
      ),
    );
  }
}
