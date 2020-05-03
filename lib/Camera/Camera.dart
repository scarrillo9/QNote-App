import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:notes_app/CloudDBWorker.dart';
import 'package:notes_app/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'CameraEntry.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  bool isInitialized = false;
  CameraController cameraController;
  CloudDBWorker cloudDB = CloudDBWorker();

  @override
  void initState() {
    super.initState();
    availableCameras().then((List<CameraDescription> value) {
      cameraController = CameraController(value[0], ResolutionPreset.medium);
    });
  }

  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isInitialized)
            ? AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              )
            : Center(child: setMainTabText('Start taking your photonotes!')),
      floatingActionButton: FloatingActionButton(
        child: Icon((isInitialized) ? Icons.camera_alt : Icons.add,
              color: Colors.white),
          onPressed: () async {
            if (!isInitialized) {
              cameraController.initialize().then((_) {
                if (!mounted) {
                  return;
                }
                setState(() => isInitialized = true);
              });
            } else {
              String imagePath = join(
                 (await getApplicationDocumentsDirectory()).path,
                 '${DateTime.now()}.png',
               );
              await cameraController.takePicture(imagePath);
              setState(() => isInitialized = false);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => CameraEntry(imagePath: imagePath)
                ),
              );
            }
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}