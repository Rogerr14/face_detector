// import 'dart:convert';
import 'dart:math';

import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum TestDetectFace {
  smileTest,
  openProbability,
  turnleftHead,
  turnRigth,
}

class FaceDetectorProvider extends ChangeNotifier {
  final List<Face> listFace = [];
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

  Future<void> analysisImage(AnalysisImage analysisImage) async {
    final inputImage = analysisImage.toInputImage();
    final faceDetector = FaceDetector(options: options);
    listFace.addAll(await faceDetector.processImage(inputImage));
    debugPrint('face:  $listFace');
    notifyListeners();
  }

  void startLiveTest() {
    if (!isAnalyzing) {
      //Aqui inciar el tiempo, el scan, y el test
      analysisController?.start();
    } else {
      analysisController?.stop();
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

  // List<Face> faceAction = [];
  // String message = '';
  // bool isActive = false;

  // Color color = Colors.white;

  // List<Face> faceCompare = [];
  // Face? previousFace;

  // bool isAlive = false;
  // int numberTest = 0;

  // Future<void> livenessTest(AnalysisController analysisController) async {
  //   switch (numberTest) {
  //     case 0:
  //       message = 'Parpadee';
  //       isActive = true;
  //       notifyListeners();
  //       await Future.delayed(const Duration(seconds: 10), () async {
  //         debugPrint('Entra al analisis');
  //         debugPrint('caras: $faceAction');
  //         isAlive = await validateOpenEyes();
  //       });
  //       break;
  //     case 1:
  //       message = 'sonria';
  //       isActive = true;

  //       notifyListeners();
  //       await Future.delayed(const Duration(seconds: 10), () async {
  //         debugPrint('Entra al analisis');
  //         debugPrint('caras: $faceAction');
  //         isAlive = await validateSmile();
  //       });
  //       break;
  //     case 2:
  //       message = 'gire la cabeza a la izquierda';
  //       isActive = true;
  //   }

  //   if (isAlive) {
  //     debugPrint('analisis valido');
  //   } else {
  //     debugPrint('analisis fallido');
  //     isActive = false;
  //     // analysisController.stop();
  //     notifyListeners();
  //   }
  // }

  // Future<bool> validateOpenEyes() async {
  //   debugPrint('caras: ${faceAction.length}');
  //   double flickerProbability = 0.0;
  //   if (faceAction.length == 5) {
  //     for (Face face in faceAction) {
  //       debugPrint('entra al test de parpadeo');
  //       debugPrint(
  //           'test flicker:  ${face.leftEyeOpenProbability}, ${face.rightEyeOpenProbability}');
  //       if (previousFace != null) {
  //         if (face.leftEyeOpenProbability !=
  //                 previousFace!.leftEyeOpenProbability &&
  //             face.rightEyeOpenProbability !=
  //                 previousFace!.rightEyeOpenProbability) {
  //           debugPrint('diferente');
  //           flickerProbability += 0.2;
  //         } else {
  //           debugPrint('no diferente');
  //           flickerProbability -= 0.2;
  //         }
  //       }
  //       previousFace = face;
  //     }
  //   }
  //   if (flickerProbability >= 0.9) {
  //     faceAction = [];
  //     previousFace = null;
  //     notifyListeners();
  //     return true;
  //   } else {
  //     faceAction = [];
  //     previousFace = null;

  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> validateSmile() async {
  //   double smileProbability = 0.0;
  //   // double currrentSmileProbability = 0.0;
  //   // double previousSmileProbability = 0.0;
  //   if (faceAction.length == 5) {
  //     for (Face face in faceAction) {
  //       debugPrint('entra al test de sonrisa');
  //       // if(previousFace != null){
  //       debugPrint('test smile: ${face.smilingProbability}');
  //       //
  //       if (face.smilingProbability! > 0.008) {
  //         debugPrint('Test smile passed');
  //         smileProbability += 0.2;
  //       } else {
  //         smileProbability -= 0.2;
  //       }
  //       // }
  //       // previousFace = face;
  //     }
  //   }
  //   if (smileProbability >= 0.8) {
  //     faceAction = [];
  //     previousFace = null;
  //     notifyListeners();
  //     return true;
  //   } else {
  //     faceAction = [];
  //     previousFace = null;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // void navigatoTo(BuildContext context) {
  //   Navigator.pushNamed(context, '/result');
  // }
}
