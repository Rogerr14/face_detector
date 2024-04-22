import 'package:flutter/material.dart';

class FaceResultPage extends StatefulWidget {
  const FaceResultPage({super.key});

  @override
  State<FaceResultPage> createState() => _FaceResultPageState();
}

class _FaceResultPageState extends State<FaceResultPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('funca bien')
        ],
      ),
    );
  }
}