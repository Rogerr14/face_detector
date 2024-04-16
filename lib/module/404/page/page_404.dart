import 'package:app_face/module/404/widgets/page_404.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: drawerWidget404(context));
  }
}
