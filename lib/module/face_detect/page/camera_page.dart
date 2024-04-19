import 'dart:async';
import 'dart:math';
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
  bool isActive = true;
  // bool hasId = false;
  // int? trackId;
  bool analyze = false;

  // final int numberTest = Random().nextInt(2);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final faceDetectorP =
        Provider.of<FaceDetectorProvider>(context, listen: false);
        final size = MediaQuery.of(context).size;

    return  Scaffold(
      appBar: AppBar(title: Text('Liveness Test'),),
      body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Visibility(visible: faceDetectorP.isActive, child: (faceDetectorP.message == '') ? Container() : Text('Por favor, ${faceDetectorP.message}')),
              ),
              (faceDetectorP.isActive) ? Container(): const SizedBox(height: 20,),
              Container(
                width: size.width * 0.8,
                height: size.height * 0.5,
                padding: const EdgeInsets.all(10),
                
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                        maxFramesPerSecond: 1,
                        cupertinoOptions: CupertinoAnalysisOptions.bgra8888(),
                      ),
                        
                      // metodo de analisis de face detection
                      onImageForAnalysis: (image) async {
                        Future.delayed(const Duration(milliseconds:  500), (){
                           _analyzeImage(image);
                        });
                        
                      } ,
                        
                      //dibujar encima de la camara
                      builder: (state, preview) {
                        analysisController = state.analysisController!;
                        return const SizedBox();
                      }),
                ),
              ),

              Padding(padding: 
              const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: OutlinedButton(child: const Text('Verificar'), onPressed: (!faceDetectorP.isActive) ? (){
                faceDetectorP.numberTest= Random().nextInt(2);
                analysisController.start();
                
                faceDetectorP.livenessTest();
                debugPrint(faceDetectorP.message);
                } : null,
              ),)
            ],
          ),
        
      ),
    );
  }








  Future _analyzeImage(AnalysisImage image) async {

    setState(() {
      isActive =false;
    });
    final fDProvider = Provider.of<FaceDetectorProvider>(context, listen: false);
try{
    final inputImage = image.toInputImage();
    fDProvider.faceAction.addAll(await faceDetector.processImage(inputImage));
    debugPrint('caras: ${fDProvider.faceAction}');

}catch (e){
  throw Exception('error: $e');
}

    

    //llamada a provider
    
    // if (fDProvider.isAlive) return;

    //   try {
    //   // face.clear();
    //       face = await faceDetector.processImage(inputImage);
     
    //           if (await fDProvider.isFaceDetect(face)) {
    //             if (analyze){
    //               debugPrint('se regresa');
    //             return;
    //             } 
    //             debugPrint('no se regresa');
    //                 analyze = true;
            

    //             if (face.isNotEmpty) {

    //               await Future.delayed(const Duration(milliseconds: 300), () async {


    //                   switch (fDProvider.numberTest) {
    //                         case 0:
    //                         setState(() {
    //                           message = 'Sonrie';
    //                           isActive = true;
    //                         });
    //                         await Future.delayed(const Duration(milliseconds: 200), () async {

    //                           for (int i = 0; i < 5; i++) {
    //                             debugPrint( 'se agrega imagen sonrisa');
    //                             fDProvider.faceAction
    //                                 .addAll(await faceDetector.processImage(inputImage));
    //                                 await Future.delayed(Duration(milliseconds: 500));
    //                           }
    //                         });
    //                         await fDProvider.validateSmile();
    //                         debugPrint('finaliza');
    //                         break;

    //                       case 1:
    //                         setState(() {
    //                           message = 'parpadea';
    //                           isActive = true;
    //                         });
    //                         await Future.delayed(const Duration(milliseconds: 200), () async {

    //                           for (int i = 0; i < 5; i++) {
    //                             fDProvider.faceAction
    //                                 .addAll(await faceDetector.processImage(inputImage));
    //                                await Future.delayed(Duration(milliseconds: 500));

    //                           }
    //                         });
    //                         await fDProvider.validateOpenEyes();
    //                         debugPrint('finaliza');
    //                         break;
    //                     }
    //                 //aqui se supone que va la navegacion en caso de que alive sea verdadero
                  
    //                 if (fDProvider.isAlive) {
    //                   face=[];
    //                   fDProvider.faceAction = [];
    //                   fDProvider.color = Colors.white;
    //                   setState(() {
    //                     isActive = false;
    //                   });
    //                   analysisController.stop();
    //                   fDProvider.navigatoTo(context);

    //                   return;
    //                 }else{
    //                   analyze = false;
    //                   setState(() {
                        
    //                   isActive = false;
    //                   });
    //                   fDProvider.color = Colors.white;
    //                   face = [];
    //                 }
    //               });
    //             }

    //             //si isAlive es false, de desbloquea el analisis nuevamente.
              
    //           }else{
    //             setState(() {
    //               isActive = false; 
    //               fDProvider.isAlive = false;
    //             }); 
    //             fDProvider.faceAction = [];
    //             face = [];
    //             return;
    //           }

    // } catch (error) {
    //   debugPrint('Error:  $error');
    // }

    //se agrega caras a la lista
  }
}
