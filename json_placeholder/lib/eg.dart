void main() async {
  final result = await getData();

  print('end: $result');
}

Future<String> getData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'hello';
}