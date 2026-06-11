import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ApiPoweredListApp());
}

// Simple model class for one API post.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

// This service keeps all networking code outside the UI.
class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final http.Response response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Something went wrong. Status: ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((dynamic item) => Post.fromJson(item as Map<String, dynamic>))
        .take(20)
        .toList();
  }

  void dispose() {
    client.close();
  }
}

class ApiPoweredListApp extends StatelessWidget {
  const ApiPoweredListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 8 API List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
        useMaterial3: true,
      ),
      home: const PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService apiService;
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    loadPosts();
  }

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  void loadPosts() {
    setState(() {
      postsFuture = apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API-powered Posts'),
        actions: <Widget>[
          IconButton(
            onPressed: loadPosts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: postsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Something went wrong while loading posts.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: loadPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Post> posts = snapshot.data ?? <Post>[];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final Post post = posts[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.title),
                  subtitle: Text(
                    post.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
