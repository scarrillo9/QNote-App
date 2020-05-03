import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/CloudDBWorker.dart';
import 'package:notes_app/utils.dart';

class CameraEntry extends StatelessWidget {
  final String imagePath;
  CloudDBWorker cloudDB = CloudDBWorker();

  CameraEntry({this.imagePath});

  @override
  Widget build(BuildContext context) {

    cloudDB.getImagesFromCloud();

    MaterialButton goBackButton() {
      return MaterialButton(
        child: Text(
          'Go Back',
          style: TextStyle(color: Colors.white),
          ),
        color: Colors.green,
        onPressed: (){
          Navigator.pop(context);
        } 
      );
    }

    SnackBar _successSnackBar() {
      return SnackBar(
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2), content: Text('Appointment saved'),
      );
    }

    MaterialButton saveButton(BuildContext context) {
      return MaterialButton(
        child: Text(
          'Save',
          style: TextStyle(color: Colors.white),
          ),
        color: Colors.green,
        onPressed: (){
          List<String> images = new List<String>.from(cloudDB.imagePaths);
          images.add(imagePath);
          cloudDB.imagePaths = images;
          cloudDB.saveInCloud('test');
          // Scaffold.of(context).showSnackBar(_successSnackBar());
          Navigator.pop(context);
        } 
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: setAppTitle('Preview Note'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(File(imagePath)),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              saveButton(context),
              goBackButton()
            ],
          )
        ],
      )
    );
  }
}