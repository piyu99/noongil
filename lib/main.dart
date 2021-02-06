import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

//List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //cameras = await availableCameras();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}
String imagePath;

GlobalKey<ScaffoldState> _scaffoldkey= GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  openGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=image;
    });
  }
  openCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image=image;
    });
  }

 // CameraController controller;

  @override
  void initState() {
    super.initState();
//    controller = CameraController(cameras[0], ResolutionPreset.high);
//    controller.initialize().then((_) {
//      if (!mounted) {
//        return;
//      }
//      setState(() {});
//    });
  }

//  @override
//  void dispose() {
//    super.dispose();
//    controller?.dispose();
//  }

  @override
  Widget build(BuildContext context) {
//    if(!controller.value.isInitialized){
//      return Container(child: Text('NoonGil cant find you!'),);

    //}
    return  SafeArea(
        key: _scaffoldkey, // Please connect an device
        child: Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  'NooNgil',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            backgroundColor: Colors.yellowAccent,
//            bottom: TabBar(
//              tabs: [
//                Icon(
//                  Icons.photo,
//                  color: Colors.black,
//                ),
//                Icon(
//                  Icons.camera_alt,
//                  color: Colors.black,
//                ),
//              ],
//            ),
          ),
          backgroundColor: Colors.white,
          body:
              Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 100,
                    child : _image==null?Container():Container(child: Text('Tap the Image to know'),color: Colors.white,),
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: 0.7,
                      child: GestureDetector(
                          child: _image==null?Center(child: Text('Select an Image')):Image.file(_image),
                        onTap: () async {
//                          String file=await getpath(_image);
//                          setState(() {
//                            imagePath=file;
//                          });
                            detectlabels(_image.path);
                        print(_image.path);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 40,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.photo,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.yellow,
                      onPressed: () {
                        openGallery();
                      },
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 40,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.yellow,
                      onPressed: () {
                        openCamera();
                      },
                    ),
                  )
                ],
              ),
              
            
          ),
        

    );
  }
}

//Future<String> getfile(String path) async {
//  final byteData=await rootBundle.load(path);
//  final Directory extDir = await getApplicationDocumentsDirectory();
//  final String dirPath = '${extDir.path}/Pictures/noongil';
//  await Directory(dirPath).create(recursive: true);
//  final String filePath='$dirPath/${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
//  final file=File(filePath);
//  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes));
//  return filePath;
//}

detectlabels(String path) async {
  final FirebaseVisionImage visionImage=FirebaseVisionImage.fromFilePath(path);
  final ImageLabeler labelDetector = FirebaseVision.instance.imageLabeler(
    ImageLabelerOptions(confidenceThreshold: 0.50));
  final List<ImageLabel> labels = await labelDetector.processImage(visionImage);

  for(ImageLabel label in labels){
    final String text=label.text;
    print(text);
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }
}

