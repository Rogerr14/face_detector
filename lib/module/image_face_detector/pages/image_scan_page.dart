import 'dart:io';
import 'dart:math';

import 'package:app_face/module/face_detect/utils/mlkit_utils.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';


class ImageScanPage extends StatefulWidget {
  const ImageScanPage({super.key});

  @override
  State<ImageScanPage> createState() => _ImageScanPageState();
}

class _ImageScanPageState extends State<ImageScanPage> {
   final ImagePicker picker = ImagePicker();
    XFile? image;
    
   Point<int>? leftEyePos;
   Point<int>? rightEyePos;
    double? distance;


  final options = FaceDetectorOptions(
    enableContours: true,
    enableLandmarks: true,
    minFaceSize: 0.8,
    performanceMode: FaceDetectorMode.fast
  );

  late final faceDetector = FaceDetector(options: options);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Imagen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Seleccione Imagen'),
            IconButton(onPressed: ()async{
              
              image = await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                
              });
            
            }, icon: Icon(Icons.image)),

            SizedBox(
              width: 300,
              height: 300,
              child: Builder(
                builder: (context) {
                  return Container(
                    width: 300,
                    height: 300,
                      child: (image != null)
                      ? Image.file(File(image!.path))
                      : SizedBox(),
                  );
                }
              ),
            ),
            SizedBox(height: 30,),
            Text('scanear puntos'),
            OutlinedButton(onPressed: (){
              if(image != null){
                final imageByte = InputImage.fromFile(File(image!.path)); 
              analyzeImage(img: imageByte);
              }


            }, child: Text('Escanear')),

            SizedBox(height: 30,),
            Text('Distancia de los ojos $distance')

            
            
          ],
        ),
      ),

    );
  }


  Future analyzeImage({required InputImage img}) async {
      if(img.metadata != null){

      debugPrint('${img.metadata!.size}');
      }
     final List<Face> faces = await faceDetector.processImage(img);
     debugPrint('${faces.first.boundingBox}');

    for(Face face in faces){
      final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
                final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
                final FaceLandmark? noseBase = face.landmarks[FaceLandmarkType.noseBase];
                final FaceLandmark? leftEar =  face.landmarks[FaceLandmarkType.leftEar];
                 final Map<FaceContourType, FaceContour?> countorn =  face.contours;
                 
                 
                  if(leftEye != null && rightEye != null){
                    leftEyePos = leftEye.position;
                    rightEyePos = rightEye.position;
                    if(rightEyePos != null){

                    int dx = rightEyePos!.x - leftEyePos!.x;
                    int dy = rightEyePos!.y - leftEyePos!.y;
                      setState(() {
                        
                     distance =  sqrt(dx * dx + dy*dy);
                      });      
                        
                      
                      debugPrint('detecta oreja: ${leftEar?.position}');
                      debugPrint('base de nariz: ${noseBase?.position}');
                      debugPrint('distancia de ojos: $distance');
                      debugPrint('Contorno del rostro ${countorn[FaceContourType.face]!.points}');
                    }


                  }    
    }
  }

}