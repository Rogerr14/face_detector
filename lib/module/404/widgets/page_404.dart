import 'package:flutter/material.dart';

@override
Widget drawerWidget404(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height,
    width: size.width,
    color: Colors.red,
    child: const Center(child: Text('Page not found')),
  );
}
