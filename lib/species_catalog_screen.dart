import 'package:flutter/material.dart';
import 'mongo_service.dart';

class SpeciesCatalogScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  SpeciesCatalogScreen({required this.user});

  @override
  _SpeciesCatalogScreenState createState() => _SpeciesCatalogScreenState();
}

class _SpeciesCatalogScreenState extends State<SpeciesCatalogScreen> {
  List<Map<String, dynamic>> _speciesList = [];
  List<Map<String, dynamic>> _filteredSpeciesList = [];
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _selectedSpecies;

  @override
  void initState() {
    super.initState();
    _loadSpecies();
    _searchController.addListener(_filterSpecies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSpecies() async {
    final species = await MongoService.getSpecies();
    setState(() {
      _speciesList = species;
      _filteredSpeciesList = species;
    });
  }

  void _filterSpecies() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSpeciesList = _speciesList.where((species) {
        return species['commonName'].toLowerCase().contains(query) ||
            species['scientificName'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectSpecies(Map<String, dynamic> species) {
    setState(() {
      _selectedSpecies = species;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Espécies'),
        backgroundColor: Color.fromARGB(255, 76, 175, 80),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Pesquisar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _selectedSpecies == null
                  ? ListView.builder(
                      itemCount: _filteredSpeciesList.length,
                      itemBuilder: (context, index) {
                        final species = _filteredSpeciesList[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              species['imageUrl'] ?? 'https://via.placeholder.com/150',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(species['commonName'] ?? 'Nome Desconhecido'),
                            subtitle: Text(species['scientificName'] ?? 'Nome Científico Desconhecido'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              _selectSpecies(species);
                            },
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() {
                                    _selectedSpecies = null;
                                  });
                                },
                              ),
                              Text(
                                'Detalhes da Espécie',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Image.network(
                            _selectedSpecies!['imageUrl'] ?? 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _selectedSpecies!['commonName'] ?? 'Nome Desconhecido',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedSpecies!['scientificName'] ?? 'Nome Científico Desconhecido',
                            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Descrição:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedSpecies!['description'] ?? 'Descrição não disponível.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
