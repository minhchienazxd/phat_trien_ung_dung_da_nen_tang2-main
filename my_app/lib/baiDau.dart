import 'package:flutter/material.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  int _valune = 0;
  Widget _buildText() {
    return Text(
      'giá trị: $_valune',
      style: const TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? title;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title:
            Text(title ?? 'btl:38\nstl:56-65\ndàn đề 36 số 17,18,19,10,45,54'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildText(),
            OutlinedButton(
              onPressed: () {
                _valune++;
                title = _valune.toString();
                setState(() {});
              },
              child: const Text('tính toán'),
            )
          ],
        ),
      ),
    ));
  }
}
// const: hằng ko thể thay đổi, chỉ duy nhất
//title ?? 'ali 22': nếu title = nolll thfi hiện cái trong ''
