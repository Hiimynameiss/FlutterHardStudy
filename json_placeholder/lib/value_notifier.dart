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
                return Text('${model.value.title} : ${model.value.body}');
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
class HttpSampleModel extends ValueNotifier<HttpSampleState> {
  // State (Value)
  // HttpSampleState _state = HttpSampleState();
  // HttpSampleState get state => _state;
  //
  // HttpSampleModel() {
  //   fetchData();
  // }

  HttpSampleModel() : super(HttpSampleState()) {
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
    // body = jsonMap['body'];
    // title = jsonMap['title'];
    // _state = state.copyWith(
    value = value.copyWith( // value라는 property에 setter, getter 모두 포함됨
      title: jsonMap['title'],
      body: jsonMap['body'],
    );

    // 외부에 알려 주자
    // notifyListeners();
  }
}

// State
class HttpSampleState {
  // String _title = '';
  // String _body = 'Loading';
  //
  // String get title => _title;
  // String get body => _body;

  // 수정 못하게 final로 지정
  final String title;
  final String body;

  HttpSampleState({
    this.title = '',
    this.body = 'Loading',
  });

  // 수정 도와주는 helper 함수
  HttpSampleState copyWith({
    String? title,
    String? body,
  }) {
    return HttpSampleState(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}