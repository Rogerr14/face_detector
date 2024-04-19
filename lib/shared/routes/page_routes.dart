


import 'package:app_face/module/404/page/page_404.dart';
import 'package:app_face/module/face_detect/page/camera_page.dart';
import 'package:app_face/module/face_result/page/face_result_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const initialroute =  '/home';

  static Map<String, WidgetBuilder> routes = {
    '/home':  (_) => const CameraPage(),
    '/result': (_) => const FaceResultPage(),

  } ;


  // static Route<dynamic> onGenerateRoute(RouteSettings settings){
  //   return MaterialPageRoute(builder: (_) => const PageNotFound() ,);
  // }

}