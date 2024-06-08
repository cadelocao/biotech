import 'package:flutter/material.dart';
import 'mongo_service.dart';
import 'login_screen.dart';
import 'tela_cadastro.dart';
import 'main_screen.dart';
import 'my_account_screen.dart';
import 'community_screen.dart';
import 'community_post_screen.dart';
import 'species_catalog_screen.dart';
import 'species_identification_screen.dart';
import 'interactive_maps_screen.dart';
import 'news_updates_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService.connect();
  runApp(BiotechApp());
}

class BiotechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biotech App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => TelaCadastro(),
        '/main': (context) => MainScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/myAccount': (context) => MyAccountScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/community': (context) => CommunityScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/addPost': (context) => CommunityPostScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/speciesCatalog': (context) => SpeciesCatalogScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/speciesIdentification': (context) => SpeciesIdentificationScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/interactiveMaps': (context) => InteractiveMapsScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/newsUpdates': (context) => NewsUpdatesScreen(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      },
    );
  }
}
