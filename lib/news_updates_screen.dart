import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl para formatação de data e hora
import 'package:url_launcher/url_launcher.dart'; // Importando o pacote url_launcher
import 'mongo_service.dart'; // Importando o serviço MongoDB

class NewsUpdatesScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  NewsUpdatesScreen({required this.user});
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias e Atualizações'),
      ),
      body: NewsUpdatesBody(),
    );
  }
}

class NewsUpdatesBody extends StatefulWidget {
  @override
  _NewsUpdatesBodyState createState() => _NewsUpdatesBodyState();
}

class _NewsUpdatesBodyState extends State<NewsUpdatesBody> {
  List<Map<String, dynamic>> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    await MongoService.connect();
    final news = await MongoService.getNews();
    news.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    setState(() {
      newsList = news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final item = newsList[index];
        final DateTime dateTime = DateTime.parse(item['date']);
        final String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
        
        return Card(
          color: item['type'] == true ? Colors.yellow[100] : Colors.white,
          margin: EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(item['title']),
            subtitle: Text(formattedDate),
            onTap: () {
              // Navegar para os detalhes da notícia
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsDetailScreen(newsItem: item)),
              );
            },
          ),
        );
      },
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsItem;

  NewsDetailScreen({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(newsItem['date']);
    final String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              newsItem['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              newsItem['description'],
              style: TextStyle(fontSize: 16),
            ),
            if (newsItem['type'] != true && newsItem.containsKey('url') && newsItem['url'].isNotEmpty) ...[
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final url = newsItem['url'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  'Leia mais',
                  style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
