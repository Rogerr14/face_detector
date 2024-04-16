import 'package:app_face/module/face_detect/provider/face_detector_provider.dart';
import 'package:app_face/shared/routes/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => FaceDetectorProvider(),)],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: AppRoute.initialroute,
        routes: AppRoute.routes,
        onGenerateRoute: AppRoute.onGenerateRoute,
        // home: CameraPage()
        // home: ImageScanPage(),
      ),
    );
  }
}