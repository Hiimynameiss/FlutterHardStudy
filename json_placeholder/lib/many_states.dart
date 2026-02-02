import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HttpSampleScreen(),
    );
  }
}

class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  String title = '';
  String body = 'Loading';

  Future<String> getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json',
      },
    );
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Sample Screen'),
      ),
      body: Center(
        // build method?
        child: FutureBuilder(
            future: getData(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                String jsonString = asyncSnapshot.data!;
                final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
                // Map jsonMap = jsonDecode(jsonString);
                title = jsonMap['title'];
                body = jsonMap['body'];
              }
              return Text('$title : $body');
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        getData();
      }),
    );
  }
}
