// import 'dart:async';
// import 'dart:math';
// import 'dart:html';
// import 'dart:math';
// import 'dart:convert';
// import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:app_face/module/face_detect/provider/face_detector_provider.dart';

import 'package:camerawesome/camerawesome_plugin.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// {  late Future<bool> isReal;
//   String message = '';
//   List<Face> face = [];
//   bool isActive = true;
//   // bool hasId = false;
//   // int? trackId;
//   bool analyze = false;
// }
  // final int numberTest = Random().nextInt(2);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;
      final  faceDetectorP = Provider.of<FaceDetectorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liveness Test'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Visibility(
                  visible: faceDetectorP.isActive,
                  child: Text('Por favor, ${faceDetectorP.message}')
                  ),
            ),
            (faceDetectorP.isActive)
                ? Container()
                : const SizedBox(
                    height: 20,
                  ),
                  AnimatedProgressBar(
                          duration: const Duration(seconds: 15), value: (faceDetectorP.isActive) ? 0.0 :1.0,
                          gradient: const LinearGradient(colors: [
                            Colors.lightGreen,
                            Colors.green,
                          ]),),
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
                    cupertinoOptions: const CupertinoAnalysisOptions.bgra8888(),
                  ),

                  // metodo de analisis de face detection
                  onImageForAnalysis: (image) =>
                      faceDetectorP.analysisImage(image),

                  //dibujar encima de la camara
                  builder: (state, preview) {
                    faceDetectorP.analysisController = state.analysisController;
                    return const SizedBox();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: OutlinedButton(
                onPressed: faceDetectorP.isAnalyzing
                    ? null
                    : () {
                        faceDetectorP.startLiveTest();
                      },
                child: const Text('Verificar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
