import 'package:flutter/material.dart';
import 'mongo_service.dart';
import 'community_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  CommunityScreen({required this.user});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> _postsList = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    final posts = await MongoService.getCommunityPosts();
    setState(() {
      _postsList = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Posts'), backgroundColor: Color.fromARGB(255, 76, 175, 80),),
      body: ListView.builder(
        itemCount: _postsList.length,
        itemBuilder: (context, index) {
          final post = _postsList[index];
          return ListTile(
            leading: post['userProfilePicture'].isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(post['userProfilePicture']),
                  )
                : CircleAvatar(
                    child: Text(post['userName'][0]),
                  ),
            title: Text(post['title'] ?? 'No Title'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['content'] ?? 'No Content'),
                SizedBox(height: 5,),
                Text('Posted by: ${post['userName']}',style: TextStyle(fontSize: 12),),
              ],
            ),
            onTap: () {
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityPostScreen(user: widget.user),
            ),
          ).then((_) => _loadPosts());
        },
      ),
    );
  }
}
