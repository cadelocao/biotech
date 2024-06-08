import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class MongoService {
  static late Db db;
  static late DbCollection speciesCollection;
  static late DbCollection newsCollection;
  static late DbCollection communityPostsCollection;
  static late DbCollection usersCollection;

  static Future<void> connect() async {
    db = await Db.create('mongodb://localhost:27017/biotech_db');
    await db.open();
    speciesCollection = db.collection('species');
    newsCollection = db.collection('news');
    communityPostsCollection = db.collection('community_posts');
    usersCollection = db.collection('users');
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> registerUser(String name, String email, String password) async {
    final hashedPassword = hashPassword(password);
    await usersCollection.insertOne({
      'name': name,
      'email': email,
      'password': hashedPassword,
      'profilePicture': '', // Campo para foto de perfil
    });
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final hashedPassword = hashPassword(password);
    final user = await usersCollection.findOne({
      'email': email,
      'password': hashedPassword,
    });
    return user != null ? {
      'id': user['_id'].toHexString(),
      'name': user['name'],
      'email': user['email'],
      'profilePicture': user['profilePicture'],
    } : null;
  }

  static Future<void> updateUserProfile(String userId, String newName, String newProfilePicture) async {
    await usersCollection.updateOne(
      where.id(ObjectId.fromHexString(userId)),
      modify.set('name', newName).set('profilePicture', newProfilePicture),
    );
  }

  static Future<bool> changePassword(String userId, String currentPassword, String newPassword) async {
  final user = await usersCollection.findOne(where.id(ObjectId.fromHexString(userId)));
  if (user != null) {
    final hashedCurrentPassword = hashPassword(currentPassword);
    if (user['password'] == hashedCurrentPassword) {
      final hashedNewPassword = hashPassword(newPassword);
      await usersCollection.updateOne(
        where.id(ObjectId.fromHexString(userId)),
        modify.set('password', hashedNewPassword),
      );
      return true;
    }
  }
  return false;
}


  static Future<List<Map<String, dynamic>>> getSpecies({String? sortBy, bool ascending = true}) async {
    final sortOrder = ascending ? 1 : -1;
    final pipeline = [
      {
        '\$sort': {sortBy ?? 'commonName': sortOrder}
      }
    ];
    final speciesStream = speciesCollection.aggregateToStream(pipeline);
    final species = await speciesStream.toList();
    return species;
  }

  static Future<List<Map<String, dynamic>>> getNews() async {
    final news = await newsCollection.find().toList();
    return news;
  }

  static Future<List<Map<String, dynamic>>> getCommunityPosts() async {
    final posts = await communityPostsCollection.find().toList();
    return posts.map((post) {
      post['_id'] = post['_id'].toString();
      return post;
    }).toList();
  }

  static Future<void> addCommunityPost(Map<String, dynamic> post) async {
    try {
      post['_id'] = ObjectId().toHexString(); // Adiciona um ObjectId convertido para string
      await communityPostsCollection.insertOne(post);
    } catch (e) {
      print("Erro ao inserir o documento: $e");
    }
  }
}
