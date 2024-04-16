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
    'positionTopMax': 140.0,
    'positionIzquierdaMin': 50.0,
    'positionIzquierdaMax': 170.0,
  };

  Color color = Colors.white;

  List<Face> faceAction = [];

  List<Face> faceCompare = [];
  List<Face> previousFace  = [];

  bool isAlive = false;
  int numberTest = 0;

  // bool? faceDetec;
  // if (faces.isNotEmpty) {
  //   //tamaño de la camara del user en el preview
  //   double? widthFace = faces.last.boundingBox.width;
  //   double? heigthFace = faces.last.boundingBox.height;
  //   //posicion de la camara del user en el preview
  //   double? topPositionFace = faces.last.boundingBox.top;
  //   double? leftPositionFace = faces.last.boundingBox.left;
  //   //probabilidad de parpadeo
  //   debugPrint('parpadeo: ${faces.last.leftEyeOpenProbability}');

  //   //detectar si la cara esta dentro del tamaño requerido
  //   if ((widthFace < maxWidth && heigthFace < maxHeigth) &&
  //       (widthFace > minWidth && heigthFace > minHeigth)) {
  //     debugPrint('tamaño bien');
  //     //detectar si la cara etsa en la posicion requeridad
  //     if ((topPositionFace < maxPositionTopFace &&
  //             leftPositionFace < maxPositionLeftFace) &&
  //         (topPositionFace > minPositionTopFace &&
  //             leftPositionFace > minPositionLeftFace)) {
  //       debugPrint('cara detectada');
  //       /*
  //                     Parametros para la deteccion de vida
  //                     -movimiento de los ojos (parpadeo)
  //                     -movimiento de la cabeza
  //                     -se ven las orejas
  //                     -movimiento de la boca
  //                     */
  //     } else {
  //       debugPrint('cara no detectada');
  //     }

  Future<bool> isFaceDetect(List<Face> faces) async {
    double widthMin = requisitosRostro['widthMin'];
    double widthMax = requisitosRostro['widthMax'];
    double heigthaMin = requisitosRostro['heigthaMin'];
    double heigthMax = requisitosRostro['heigthMax'];
    double positionTopMin = requisitosRostro['positionTopMin'];
    double positionTopMax = requisitosRostro['positionTopMax'];
    double positionLeftMin = requisitosRostro['positionIzquierdaMin'];
    double positionLeftMax = requisitosRostro['positionIzquierdaMax'];

    if (faces.isNotEmpty) {
      debugPrint('Paso 1 ok');
      // for (Face faces.last in faces) {
        debugPrint('Paso 2 ok');
       

        if ((faces.last.boundingBox.width <= widthMax && faces.last.boundingBox.height <= heigthMax) &&(faces.last.boundingBox.width >= widthMin && faces.last.boundingBox.height >= heigthaMin)) {
          debugPrint('Paso 3 ok');
           debugPrint('paso 3.0: ${faces.last.boundingBox.top <= positionTopMax} ');
      

        debugPrint('paso 3.1: ${faces.last.boundingBox.left <= positionLeftMax} ');
        debugPrint('paso 3.2: ${faces.last.boundingBox.top >= positionTopMin} ');
        debugPrint('paso 3.3: ${faces.last.boundingBox.left >= positionLeftMin} ');
          debugPrint('paso 3.3: ${faces.last.boundingBox.left} ');
        debugPrint('paso 3:----------------------------------------------- ');
          if ((faces.last.boundingBox.top <= positionTopMax &&
                  faces.last.boundingBox.left <= positionLeftMax) &&
              (faces.last.boundingBox.top >= positionTopMin &&
                  faces.last.boundingBox.left >= positionLeftMin)) {
                    debugPrint('Paso 4 ok');
            debugPrint('cara desigual');
            faceCompare = faces;
            color = Colors.green;
            numberTest = Random().nextInt(2);
            notifyListeners();
            
            return true;
          }
        // }
      }
    }
    // debugPrint('sin cara');
    faces = [];
    faceCompare = [];

    color = Colors.white;
    notifyListeners();
    return false;
  }

  Future<bool> validateOpenEyes() async {
    

    
      if (previousFace.isNotEmpty) {
        // Verificar si hay un cambio significativo en las probabilidades de apertura de los ojos
        double leftEyeChange = faceAction.last.leftEyeOpenProbability! -
            previousFace.last.leftEyeOpenProbability!;
        double rightEyeChange = faceAction.last.rightEyeOpenProbability! -
            previousFace.last.rightEyeOpenProbability!;

        // Verificar si al menos una de las probabilidades de los ojos cambia significativamente
        if (leftEyeChange < -0.2 || rightEyeChange < -0.2) {
          return true;
          // notifyListeners(); // Se detectó un parpadeo
        }
      
       // notifyListeners(); // No se detectó ningún parpadeo
      
    }
      previousFace = faceAction;
       return false;
        
  }

  Future<bool> validateSmile() async {
    debugPrint('si entra aqui');
    debugPrint('entra: $faceAction');

      if (previousFace.isNotEmpty) {
        double smileProbability =
            faceAction.last.smilingProbability! - previousFace.last.smilingProbability!;
        debugPrint('sonrisa: $smileProbability');
        if (smileProbability < 0.2) {
          debugPrint('sonrisa valida');
          isAlive = true;
          notifyListeners();
        } else {
          debugPrint('no es valido');
        }
      } 

       previousFace = faceAction;
        return false;
      }
  
  
}
