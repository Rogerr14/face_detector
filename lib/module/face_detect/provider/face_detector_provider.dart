
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorProvider extends ChangeNotifier {
  final Map<String, dynamic> requisitosRostro = {
    'widthMin': 410.0,
    'widthMax': 610.0,
    'heigthaMin': 550.0,
    'heigthMax': 650.0,
    'positionTopMin': 60.0,
    'positionTopMax': 130.0,
    'positionIzquierdaMin': 60.0,
    'positionIzquierdaMax': 120.0,
  };

  Color color = Colors.white;

  List<Face> faceAction = [];
  List<Face> faceCompare = [];
  Face? previousFace;

  bool isAlive = false;
  int numberTest = 0;

  

  Future<bool> isFaceDetect(List<Face> faces) async {
    // double widthMin = requisitosRostro['widthMin'];
    // double widthMax = requisitosRostro['widthMax'];
    // double heigthaMin = requisitosRostro['heigthaMin'];
    // double heigthMax = requisitosRostro['heigthMax'];
    double positionTopMin = requisitosRostro['positionTopMin'];
    double positionTopMax = requisitosRostro['positionTopMax'];
    double positionLeftMin = requisitosRostro['positionIzquierdaMin'];
    double positionLeftMax = requisitosRostro['positionIzquierdaMax'];

    if (faces.isNotEmpty) {
      debugPrint('Paso 1 ok');
     
        debugPrint('paso 1.0:${faces.last.boundingBox.top} ');
        debugPrint('paso 1.1:${faces.last.boundingBox.left} ');
        /*
            'positionTopMin': 60.0,
    'positionTopMax': 140.0,
    'positionIzquierdaMin': 50.0,
    'positionIzquierdaMax': 170.0,
        */
     
      
        if ((faces.last.boundingBox.top <= positionTopMax &&
                faces.last.boundingBox.left <= positionLeftMax) &&
            (faces.last.boundingBox.top >= positionTopMin &&
                faces.last.boundingBox.left >= positionLeftMin)) {
                  debugPrint('cara detectada');
          faceCompare = faces;
          color = Colors.green;
          numberTest = Random().nextInt(2);
          notifyListeners();

          return true;
        }
        // }
      
    }
 
    faces = [];
    faceCompare = [];

    color = Colors.white;
    notifyListeners();
    return false;
  }

  Future<void> validateOpenEyes() async {
    debugPrint('caras: ${faceAction.length}');
    double flickerProbability = 0.0;
    for(Face face in faceAction){
      debugPrint('entra al test de parpadeo');
      debugPrint('test flicker:  ${face.leftEyeOpenProbability}, ${face.rightEyeOpenProbability}');
      if(previousFace != null){
         if(face.leftEyeOpenProbability != previousFace!.leftEyeOpenProbability && face.rightEyeOpenProbability != previousFace!.rightEyeOpenProbability ){
          debugPrint('diferente');
          flickerProbability += 0.2;
         }else{
           debugPrint('no diferente');
          flickerProbability -= 0.2;
         }

      }
        previousFace = face;
    }
      if(flickerProbability >= 0.8){
         faceAction = [];
        isAlive = true;
        previousFace = null;
        notifyListeners();
      }else{
        faceAction = [];
        isAlive = false;
        previousFace = null;
        notifyListeners();
      }
  
  }

  Future<void> validateSmile() async {
    debugPrint('caras: ${faceAction.length}');
        double smileProbability = 0.0;

    for(Face face in faceAction){
      debugPrint('entra al test de sonrisa');
      debugPrint('test smile = ${face.smilingProbability}');
          if(face.smilingProbability! <= 0.2){
            smileProbability += 0.2;
          }else{
            smileProbability -= 0.2;
          }
    }
    if(smileProbability >= 0.8){
      isAlive = true;
      faceAction = [];
      previousFace = null;
      notifyListeners();
    }else{
      faceAction = [];
      isAlive = false;
      previousFace = null;
      notifyListeners();
    }


  }

void navigatoTo(BuildContext context){
  Navigator.pushNamed(context, '/result');
}
}