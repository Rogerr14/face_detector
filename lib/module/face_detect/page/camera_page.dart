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
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  void activate() {
    // TODO: implement activate

    super.activate();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate

    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // analysisController!.stop();
    faceDetector.close();
    super.dispose();
  }

  late Future<bool> isReal;
  String message = '';
  List<Face> face = [];
  bool isActive = false;
  bool hasId = false;
  int? trackId;
      int llamada = 0;
  bool analyze = true ; 

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
                      // autoStart: false,
                      androidOptions:
                          const AndroidAnalysisOptions.nv21(width: 250),
                      maxFramesPerSecond: 5,
                      cupertinoOptions: CupertinoAnalysisOptions.bgra8888(),
                    ),

                    // metodo de analisis de face detection
                    onImageForAnalysis:(image) async {
                      // if(face.isEmpty) analysisController!.start();
                      if(analyze) await  _analyzeImage(image);
                    },

                    //dibujar encima de la camara
                    builder: (state, preview) {
                    
                      // if (face.isEmpty) analysisController!.start();

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
    debugPrint('llamada: $llamada');
    llamada++;
    final fDProvider =
        Provider.of<FaceDetectorProvider>(context, listen: false);
    
    try {
      // face.clear();
      final inputImage = image.toInputImage();
      face = await faceDetector.processImage(inputImage);
      debugPrint('face: $face');
      
      if (!hasId) {
        if (face.isNotEmpty) {
          setState(() {
            hasId = true;
            trackId = face.first.trackingId;
          });
        }
      }
      if (face.isNotEmpty) {
       
        if (face.last.trackingId == trackId) {
          // bool faceDetect = await fDProvider.isFaceDetect(face);
          if (await fDProvider.isFaceDetect(face)) {
            
        switch (fDProvider.numberTest) {
          case 0:
          debugPrint('Entra al test 1');
            setState(() {
              message = 'Sonrie';
              isActive = true;
            });
            fDProvider.faceAction = await faceDetector.processImage(inputImage);
           await Future.delayed(const Duration(seconds: 5),  ()async {
              setState(() {
                analyze = false;

              });
              await fDProvider.validateSmile();
              debugPrint('finaliza');

            });
            break;

          case 1:
            debugPrint('Entra al test 2');
            setState(() {
              message = 'parpadea';
              isActive = true;
            });
            fDProvider.faceAction = await faceDetector.processImage(inputImage);
            await Future.delayed(Duration(seconds: 5),()async{
            setState(() {
              analyze =false;
            });
                await fDProvider.validateOpenEyes();
                debugPrint('finaliza');
            });
            break;

          default:
          debugPrint('Entra al test 3');
             setState(() {
              message = 'Sonrie';
              isActive = true;
            });
            fDProvider.faceAction = await faceDetector.processImage(inputImage);
            await Future.delayed(Duration(seconds: 5),  ()async {
              setState(() {
                analyze = false;
              });


                              await fDProvider.validateOpenEyes();
              debugPrint('finaliza');
             
              
            });
            
            break;
        }
        


           }}}
      // debugPrint('cara: $face');

      // bool faceDetect = await fDProvider.isFaceDetect(face);
      // if(face.isNotEmpty){
      // debugPrint('id: ${face.last.trackingId}');

      // }
      // if(faceDetect){

      //   face.clear();
      //   debugPrint('cara detectada');
      //   fDProvider.faceAction.addAll(await faceDetector.processImage(inputImage));
      //   debugPrint('caras: ${fDProvider.faceAction}');
      //   setState(() {
      //         message = 'Sonrie';
      //         isActive = true;
      //       });
      //   await Future.delayed(Duration(seconds: 20));

      // }

      // if (faceDetect) {
      //   fDProvider.faceAction.addAll(await faceDetector.processImage(inputImage));
      //   switch (fDProvider.numberTest) {
      //     case 0:
      //       setState(() {
      //         message = 'Sonrie';
      //         isActive = true;
      //       });
      //       await Future.delayed(Duration(seconds: 10));
      //       analysisController!.stop();
      //       await fDProvider.validateSmile();
      //       break;

      //     case 1:
      //       setState(() {
      //         message = 'parpadea';
      //         isActive = true;
      //       });
      //       await Future.delayed(Duration(seconds: 10));
      //       analysisController!.stop();

      //       fDProvider.validateOpenEyes(context);
      //       break;

      //     default:
      //       setState(() {
      //         message = 'Sonrie';
      //         isActive = true;
      //       });
      //       await Future.delayed(Duration(seconds: 10));
      //       analysisController!.stop();
      //       await fDProvider.validateSmile();
      //       break;
      //   }
      //   //  setState(() {
      //   hasAnalize = true;
      //       analyze = false;
      //     });

      // switch (fDProvider.numberTest) {
      //   case 0:
      //     // await Future.delayed(const Duration(seconds: 10), );
      //     debugPrint('validacion 1');
      //     await fDProvider.validateSmile();

      //     break;
      //   case 1:
      //     // await Future.delayed(const Duration(seconds: 10), );
      //     debugPrint('validacion 2');
      //     await fDProvider.validateOpenEyes();

      //     break;
      //   default:
      //     // await Future.delayed(const Duration(seconds: 10), );
      //     debugPrint('validacion 1');
      //     await fDProvider.validateSmile();

      //     break;
      // }
      // debugPrint('Paso 4');
    //   debugPrint('vivo: ${fDProvider.isAlive}');
    } catch (error) {
      debugPrint('Error:  $error');
    }

    //se agrega caras a la lista
  }
}
