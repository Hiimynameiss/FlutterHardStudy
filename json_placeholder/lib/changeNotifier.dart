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

// Screen (UI)
class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  final model = HttpSampleModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Sample Screen'),
      ),
      body: Center(
          child: ListenableBuilder(
              listenable: model,
              builder: (BuildContext context, Widget? child) {
                return Text('${model.title} : ${model.body}');
              }
          )
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        model.fetchData();
      }),
    );
  }
}

// Model (State, Logic)
class HttpSampleModel with ChangeNotifier {
  // State
  String _title = '';
  String _body = 'Loading';

  String get title => _title;
  String get body => _body;

  HttpSampleModel() {
    fetchData();
  }

  // Logic
  Future<String> _getData() async {
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

  // State Func.
  void fetchData() async {
    final jsonString = await _getData();
    final jsonMap = jsonDecode(jsonString) as Map;

    // 상태 변경
    _body = jsonMap['body'];
    _title = jsonMap['title'];

    // 외부에 알려 주자
    notifyListeners();
  }
}