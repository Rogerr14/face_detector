// import 'dart:convert';
// import 'dart:math';

import 'dart:async';
import 'dart:math';

import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorProvider extends ChangeNotifier {
  List<Face> listFace = [];
  List<Face> previousFace = [];
  final options = FaceDetectorOptions(
    enableContours: true,
    performanceMode: FaceDetectorMode.accurate,
    enableClassification: true,
    minFaceSize: 0.5,
    // enableLandmarks: true,
    enableTracking: true,
  );
  bool isAnalyzing = false;
  bool isActive = false;
  bool result = false;

  // bool isAlive = false;
  AnalysisController? analysisController;
  String message = '';
  String resultMessage = '';
  int numberTest = 0;
  int idFace = 0;
  double probability = 0;

  // Face? previousFace;
  StreamController<List<Face>> streamFace = StreamController.broadcast();
  StreamSubscription<List<Face>>? subscription;
  // int counter = 14;

  Future<void> analysisImage(AnalysisImage analysisImage) async {
    final faceDetector = FaceDetector(options: options);
    final inputImage = analysisImage.toInputImage();
    listFace = await faceDetector.processImage(inputImage);

    streamFace.add(listFace);
    debugPrint('caras: $listFace');
    notifyListeners();
  }

  void startLiveTest() {
    if (!isAnalyzing) {
      //Aqui inciar el tiempo, el scan, y el test
      analysisController?.start();
      numberTest = Random().nextInt(3);
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
        message = 'Sonria';
        isActive = true;
        validateSmile();
        notifyListeners();
        break;
      case 1:
        message = 'Parpadee';
        isActive = true;
        validateOpenEyes();
        notifyListeners();
        break;
      case 2:
        message = 'gire la cabeza a la izquierda';
        isActive = true;
        validateTurnHead();
        notifyListeners();
    }
  }

  void validateOpenEyes() {
    debugPrint('imprime una vez');
        debugPrint('cara previa guardada: $previousFace');

    subscription?.cancel();
    subscription = streamFace.stream.take(15).listen(
      (face) async {
        debugPrint('analisis in progress..');
        if (face.isNotEmpty) {
          if (previousFace.isNotEmpty) {
          if (face.last.trackingId == idFace) {
            debugPrint('cara la misma');

              if (face.last.leftEyeOpenProbability !=
                      previousFace.last.leftEyeOpenProbability &&
                  face.last.rightEyeOpenProbability !=
                      previousFace.last.rightEyeOpenProbability) {
                debugPrint('diferente');
                probability += 0.2;
              }
            if (probability >= 0.8) {
              previousFace.clear();
              isActive = false;
              isAnalyzing = false;
              result = true;
              resultMessage = 'Esta vivo';
              analysisController!.stop();
              subscription?.cancel();
              probability = 0;
              debugPrint('analisis exitoso');
              notifyListeners();
            }
            //   if(face.last.smilingProbability! > 0.08){
            //        isActive = false;
            // isAnalyzing = false;
            // analysisController!.stop();
            //   subscription?.cancel();
            //     debugPrint('analisis exitoso');
            //   notifyListeners();
            //   }
            }
          else {
            previousFace.clear();
            probability = 0;

            isActive = false;
            isAnalyzing = false;
            analysisController!.stop();
            subscription?.cancel();

            notifyListeners();
            debugPrint('cara no la misma');
          } 
          }else{
            idFace = face.last.trackingId!;
          }
          previousFace = face;
        }
      },
      onDone: () {
        previousFace.clear();
        isActive = false;
        probability = 0;
        isAnalyzing = false;
        analysisController!.stop();
        subscription?.cancel();
        notifyListeners();
        debugPrint('analisis finalizado');
      },
    );
  }

  void validateTurnHead(){
    subscription?.cancel();
    subscription = streamFace.stream
    .take(15)
    .listen((face) {
      if(face.isNotEmpty){
        if(previousFace.isNotEmpty){
          if(face.last.trackingId == idFace){
            if(face.last.headEulerAngleY! > 30){

              previousFace.clear();
              isActive = false;
              isAnalyzing = false;
              result = true;
              resultMessage = 'Esta vivo';
              analysisController!.stop();
              subscription?.cancel();
              probability = 0;
              debugPrint('analisis exitoso');
              notifyListeners();
            }
            

          }else{
            debugPrint('cara no la misma');
            previousFace.clear();
            isActive = false;
            isAnalyzing = false;
            probability = 0;

            analysisController!.stop();
            subscription?.cancel();
            debugPrint('analisis exitoso');
            notifyListeners();
          }
            

        }else{
            idFace = face.last.trackingId!;
        }
        previousFace = face;
      }
    },
    onDone: () {
      probability = 0;

        isActive = false;
        isAnalyzing = false;
        analysisController!.stop();
        subscription?.cancel();
        previousFace.clear();
        notifyListeners();
        debugPrint('analisis finalizado');
    },
    
    );

  }

  void validateSmile() {
    debugPrint('imprime una vez');
    debugPrint('cara previa guardada: $previousFace');
   
    subscription?.cancel();
    subscription = streamFace.stream.take(15).listen(
      (face) async {
        debugPrint('analisis in progress..');
        if (face.isNotEmpty) {
          debugPrint('cara previa: $previousFace');
          if(previousFace.isNotEmpty){

          if (face.last.trackingId == idFace) {
            debugPrint('cara la misma');

            debugPrint('smileProbability: ${listFace.last.smilingProbability}');

            if (face.last.smilingProbability! > 0.08) {
              probability += 0.2;
            }
            if (probability >= 0.8) {
              previousFace.clear();
              isActive = false;
              isAnalyzing = false;
              result = true;
              resultMessage = 'Esta vivo';
              analysisController!.stop();
              subscription?.cancel();
              probability = 0;
              debugPrint('analisis exitoso');
              notifyListeners();
            }
          } else {
            debugPrint('cara no la misma');
            previousFace.clear();
            isActive = false;
            isAnalyzing = false;
            probability = 0;

            analysisController!.stop();
            subscription?.cancel();
            debugPrint('analisis exitoso');
            notifyListeners();
          }
          }else{
            idFace = face.last.trackingId!;
          }
          previousFace = face;
        }
      },
      onDone: () {
        probability = 0;

        isActive = false;
        isAnalyzing = false;
        analysisController!.stop();
        subscription?.cancel();
        previousFace.clear();
        notifyListeners();
        debugPrint('analisis finalizado');
      },
    );
  }

  // void pauseSubscription() {
  //   subscription?.cancel();
  // }

  // void navigatoTo(BuildContext context) {
  //   Navigator.pushNamed(context, '/result');
  // }
}
