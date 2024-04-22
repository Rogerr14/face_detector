// import 'dart:convert';
// import 'dart:math';

import 'dart:async';

import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorProvider extends ChangeNotifier {
  List<Face> listFace = [];
  final options = FaceDetectorOptions(
    enableContours: true,
    performanceMode: FaceDetectorMode.accurate,
    enableClassification: true,
    minFaceSize: 0.5,
    enableLandmarks: true,
    enableTracking: true,
  );
  bool isAnalyzing = false;
  AnalysisController? analysisController;
  String message = '';
  int numberTest = 0;
  bool isActive = false;
  bool isAlive = false;
  Face? previousFace;
  StreamController<List<Face>> streamFace = StreamController();
  int counter = 14;

  Future<void> analysisImage(AnalysisImage analysisImage) async {
    final faceDetector = FaceDetector(options: options);
    final inputImage = analysisImage.toInputImage();
    listFace = await faceDetector.processImage(inputImage);
    await Future.delayed(Duration(seconds: 1));
    streamFace.add(listFace);
    // debugPrint('caras: $listFace');
    notifyListeners();
  }

  void startLiveTest() {
    if (!isAnalyzing) {
      //Aqui inciar el tiempo, el scan, y el test
      analysisController?.start();
      livenessTest();
      notifyListeners();
    }
    isAnalyzing = !isAnalyzing;
    notifyListeners();
  }

  // final Map<String, dynamic> requisitosRostro = {
  //   'widthMin': 410.0,
  //   'widthMax': 610.0,
  //   'heigthaMin': 550.0,
  //   'heigthMax': 650.0,
  //   'positionTopMin': 100.0,
  //   'positionTopMax': 170.0,
  //   'positionIzquierdaMin': 50.0,
  //   'positionIzquierdaMax': 120.0,
  // };

  // List<Face> listFace = [];

  // Color color = Colors.white;

  // List<Face> faceCompare = [];

  Future<void> livenessTest() async {
    switch (numberTest) {
      case 0:
        message = 'Parpadee';
        isActive = true;
        validateSmile();
        notifyListeners();
        break;
      case 1:
        message = 'sonria';
        isActive = true;

        notifyListeners();
        break;
      case 2:
        message = 'gire la cabeza a la izquierda';
        isActive = true;
    }
  }

  void validateSmile() {
    streamFace.stream.listen((face) async {
      
      // await Future.delayed(Duration(seconds: 1));
      debugPrint('entra a stream');
      if (counter != 1) {
        if (face.isNotEmpty) {
          if (face.last.smilingProbability! > 0.008) {
            debugPrint('Sonrisa valida');
            isActive = false;
            isAnalyzing = false;
            analysisController!.stop();
            streamFace.isClosed;
            notifyListeners();
          }
        } else {
          counter--;
          notifyListeners();
        }
      } else {
        debugPrint('time sonrisa out');
        isActive = false;
        isAnalyzing = false;
        analysisController!.stop();
        streamFace.isClosed;
        notifyListeners();
      }
    });
    // subscription.pause();

    // double smileProbability = 0.0;
    // // double currrentSmileProbability = 0.0;
    // // double previousSmileProbability = 0.0;
    // if (listFace.length == 5) {
    //   for (Face face in listFace) {
    //     debugPrint('entra al test de sonrisa');
    //     // if(previousFace != null){
    //     debugPrint('test smile: ${face.smilingProbability}');
    //     //
    //     if (face.smilingProbability! > 0.008) {
    //       debugPrint('Test smile passed');
    //       smileProbability += 0.2;
    //     } else {
    //       smileProbability -= 0.2;
    //     }
    //     // }
    //     // previousFace = face;
    //   }
    // }
    //
  }

  void navigatoTo(BuildContext context) {
    Navigator.pushNamed(context, '/result');
  }
}
