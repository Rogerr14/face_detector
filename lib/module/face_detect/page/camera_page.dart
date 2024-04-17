import 'dart:async';
// import 'dart:html';
// import 'dart:math';
// import 'dart:convert';
import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:app_face/module/face_detect/provider/face_detector_provider.dart';

import 'package:camerawesome/camerawesome_plugin.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final options = FaceDetectorOptions(
    enableContours: true,
    performanceMode: FaceDetectorMode.accurate,
    enableClassification: true,
    minFaceSize: 0.5,
    enableLandmarks: true,
    enableTracking: true,
  );
  late final faceDetector = FaceDetector(options: options);
  late AnalysisController analysisController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    analysisController.stop();
    faceDetector.close();
    super.dispose();
  }

  late Future<bool> isReal;
  String message = '';
  List<Face> face = [];
  bool isActive = false;
  // bool hasId = false;
  // int? trackId;
  bool analyze = false;

  // final int numberTest = Random().nextInt(2);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final faceDetectorP =
        Provider.of<FaceDetectorProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento facial'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Visibility(visible: isActive, child: Text('Por favor, $message')),
            Container(
              width: 200,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: faceDetectorP.color,
                  borderRadius: BorderRadius.circular(120)),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.elliptical(120, 120),
                    bottom: Radius.elliptical(120, 120)),
                child: CameraAwesomeBuilder.previewOnly(
                    progressIndicator: const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                    // diseño del preview de la camara
                    previewFit: CameraPreviewFit.cover,
                    //configuracion del Sensor de la camara
                    sensorConfig: SensorConfig.single(
                        sensor: Sensor.position(SensorPosition.front),
                        aspectRatio: CameraAspectRatios.ratio_4_3),
                    //configuracion de la resolucion de la camara
                    imageAnalysisConfig: AnalysisConfig(
                      autoStart: false,
                      androidOptions:
                          const AndroidAnalysisOptions.nv21(width: 250),
                      maxFramesPerSecond: 5,
                      cupertinoOptions: CupertinoAnalysisOptions.bgra8888(),
                    ),

                    // metodo de analisis de face detection
                    onImageForAnalysis: (image) async {
                      // if(face.isEmpty) analysisController!.start();
                      await _analyzeImage(image);
                    },

                    //dibujar encima de la camara
                    builder: (state, preview) {
                      analysisController = state.analysisController!;
                      if (face.isEmpty) analysisController.start();

                      return const SizedBox();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _analyzeImage(AnalysisImage image) async {
    //conversion de imagen y llamada a provider
    debugPrint('analisis: $analyze');
    debugPrint('inicia analisis');
    final fDProvider =
        Provider.of<FaceDetectorProvider>(context, listen: false);
    if (fDProvider.isAlive) return;

    try {
      // face.clear();
      final inputImage = image.toInputImage();
      face = await faceDetector.processImage(inputImage);
      if (await fDProvider.isFaceDetect(face)) {
       
        if (analyze) return;
        debugPrint('Paso');
        analyze = true;
    

        if (face.isNotEmpty) {
     


          await Future.delayed(Duration(milliseconds: 300), () async {


            switch (fDProvider.numberTest) {
              case 0:
                
                setState(() {
                  message = 'Sonrie';
                  isActive = true;
                });
                await Future.delayed(const Duration(milliseconds: 200), () async {
                  debugPrint('testeando');
                  // fDProvider.faceAction.addAll(await faceDetector.processImage(inputImage));
                  for (int i = 0; i < 5; i++) {
                    fDProvider.faceAction
                        .addAll(await faceDetector.processImage(inputImage));
                  }
                });
                await fDProvider.validateSmile();
                debugPrint('finaliza');
                break;

              case 1:
                setState(() {
                  message = 'parpadea';
                  isActive = true;
                });
                await Future.delayed(const Duration(seconds: 3), () async {
                  debugPrint('testeando');
                  // fDProvider.faceAction.addAll(await faceDetector.processImage(inputImage));
                  for (int i = 0; i < 5; i++) {
                    fDProvider.faceAction
                        .addAll(await faceDetector.processImage(inputImage));
                  }
                });
                await fDProvider.validateOpenEyes();
                // await Future.delayed(Duration(seconds: 5));
                // fDProvider.faceAction.addAll( await faceDetector.processImage(inputImage));
                debugPrint('finaliza');
                break;
            }
            //aqui se supone que va la navegacion en caso de que alive sea verdadero
           
            if (fDProvider.isAlive) {
              debugPrint('aqui finalizó la prueba');
            
              // face = [];
              fDProvider.faceAction = [];
              fDProvider.color = Colors.white;
              setState(() {
                isActive = false;
              });
              analysisController.stop();
              fDProvider.navigatoTo(context);

              return;
            }else{
              analyze = false;
              setState(() {
                
              isActive = false;
              });
              fDProvider.color = Colors.white;
            }
          });
        }

        //si isAlive es false, de desbloquea el analisis nuevamente.
      
      }else{
        setState(() {
        isActive = false; 
          
        });
        
        fDProvider.faceAction = [];
      }

    } catch (error) {
      debugPrint('Error:  $error');
    }

    //se agrega caras a la lista
  }
}
