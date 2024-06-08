import 'package:flutter/material.dart';
import 'my_account_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'community_screen.dart';
import 'species_catalog_screen.dart';
import 'species_identification_screen.dart';
import 'interactive_maps_screen.dart';
import 'news_updates_screen.dart';

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  MainScreen({required this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic> user;

  _MainScreenState() : user = {};

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void _updateUserProfile(Map<String, dynamic> updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biotech App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user['name']),
              accountEmail: Text(user['email']),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user['profilePicture'].isNotEmpty
                    ? NetworkImage(user['profilePicture'])
                    : null,
                child: user['profilePicture'].isEmpty
                    ? Text(
                        user['name'][0],
                        style: TextStyle(fontSize: 40.0),
                      )
                    : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(user: user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Minha Conta'),
              onTap: () async {
                final updatedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountScreen(user: user)),
                );
                if (updatedUser != null) {
                  _updateUserProfile(updatedUser);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildMenuButton(
              icon: FontAwesomeIcons.bookOpen,
              label: 'Catálogo de Espécies',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeciesCatalogScreen(user: user),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              icon: FontAwesomeIcons.search,
              label: 'Identificação de Espécies',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeciesIdentificationScreen(user: user),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              icon: FontAwesomeIcons.map,
              label: 'Mapas Interativos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InteractiveMapsScreen(user: user),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              icon: FontAwesomeIcons.newspaper,
              label: 'Notícias e Atualizações',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsUpdatesScreen(user: user),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              icon: FontAwesomeIcons.users,
              label: 'Comunidade',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityScreen(user: user),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 18, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 158, 76, 175), // Cor de fundo
        foregroundColor: Color.fromARGB(255, 255, 255, 255), // Cor do texto e ícone
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Bordas arredondadas
        ),
        shadowColor: Colors.black, // Cor da sombra
        elevation: 10, // Tamanho da sombra
      ),
    );
  }
}
