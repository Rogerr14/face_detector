// import 'dart:convert';
import 'dart:math';

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
  final Map<String, dynamic> requisitosRostro = {
    'widthMin': 410.0,
    'widthMax': 610.0,
    'heigthaMin': 550.0,
    'heigthMax': 650.0,
    'positionTopMin': 100.0,
    'positionTopMax': 170.0,
    'positionIzquierdaMin': 50.0,
    'positionIzquierdaMax': 120.0,
  };

  List<Face> faceAction = [];
  String message = '';
  bool isActive = false;

  Color color = Colors.white;

  List<Face> faceCompare = [];
  Face? previousFace;

  bool isAlive = false;
  int numberTest = 0;

  // Future<bool> isFaceDetect(List<Face> faces) async {

  //   double positionTopMin = requisitosRostro['positionTopMin'];
  //   double positionTopMax = requisitosRostro['positionTopMax'];
  //   double positionLeftMin = requisitosRostro['positionIzquierdaMin'];
  //   double positionLeftMax = requisitosRostro['positionIzquierdaMax'];

  //   if (faces.isNotEmpty) {
  //     debugPrint('Paso 1 ok');
  //        debugPrint('CARA: ${faces.first.boundingBox}');
  //       debugPrint('paso 1.0:${faces.last.boundingBox.top} ');
  //       debugPrint('paso 1.1:${faces.last.boundingBox.left} ');

  //       /*
  //           'positionTopMin': 60.0,
  //   'positionTopMax': 140.0,
  //   'positionIzquierdaMin': 50.0,
  //   'positionIzquierdaMax': 170.0,
  //       */

  //       if ((faces.last.boundingBox.top <= positionTopMax &&
  //               faces.last.boundingBox.left <= positionLeftMax) &&
  //           (faces.last.boundingBox.top >= positionTopMin &&
  //               faces.last.boundingBox.left >= positionLeftMin)) {
  //                 debugPrint('cara detectada');
  //         faceCompare = faces;
  //         color = Colors.green;
  //         numberTest = Random().nextInt(2);
  //         notifyListeners();

  //         return true;
  //       }
  //       // }

  //   }

  //   faces = [];
  //   faceCompare = [];

  //   color = Colors.white;
  //   notifyListeners();
  //   return false;
  // }

  Future<void> livenessTest() async {
    switch (numberTest) {
      case 0:
        message = 'Parpadee';
        isActive = true;
        notifyListeners();
        await Future.delayed(const Duration(seconds: 10), () async {
          isAlive = await validateOpenEyes();
        });
        break;
      case 1:
        message = 'sonria';
        isActive = true;

        notifyListeners();
        await Future.delayed(const Duration(seconds: 10), () async {
          isAlive = await validateSmile();
        });
        break;
      case 2:
        message = 'gire la cabeza a la izquierda';
        isActive = true;
    }

    if (isAlive) {
      debugPrint('analisis valido');
    } else {
      debugPrint('analisis fallido');
      isActive
    }
  }

  Future<bool> validateOpenEyes() async {
    debugPrint('caras: ${faceAction.length}');
    double flickerProbability = 0.0;
    if (faceAction.length == 5) {
      for (Face face in faceAction) {
        debugPrint('entra al test de parpadeo');
        debugPrint(
            'test flicker:  ${face.leftEyeOpenProbability}, ${face.rightEyeOpenProbability}');
        if (previousFace != null) {
          if (face.leftEyeOpenProbability !=
                  previousFace!.leftEyeOpenProbability &&
              face.rightEyeOpenProbability !=
                  previousFace!.rightEyeOpenProbability) {
            debugPrint('diferente');
            flickerProbability += 0.2;
          } else {
            debugPrint('no diferente');
            flickerProbability -= 0.2;
          }
        }
        previousFace = face;
      }
    }
    if (flickerProbability >= 0.9) {
      faceAction = [];
      previousFace = null;
      notifyListeners();
      return true;
    } else {
      faceAction = [];
      previousFace = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> validateSmile() async {
    double smileProbability = 0.0;
    // double currrentSmileProbability = 0.0;
    // double previousSmileProbability = 0.0;
    if (faceAction.length == 5) {
      for (Face face in faceAction) {
        debugPrint('entra al test de sonrisa');
        // if(previousFace != null){
        debugPrint('test smile: ${face.smilingProbability}');
        //
        if (face.smilingProbability! > 0.008) {
          debugPrint('Test smile passed');
          smileProbability += 0.2;
        } else {
          smileProbability -= 0.2;
        }
        // }
        // previousFace = face;
      }
    }
    if (smileProbability >= 0.8) {
      faceAction = [];
      previousFace = null;
      notifyListeners();
      return true;
    } else {
      faceAction = [];
      previousFace = null;
      notifyListeners();
      return false;
    }
  }

  void navigatoTo(BuildContext context) {
    Navigator.pushNamed(context, '/result');
  }
}
