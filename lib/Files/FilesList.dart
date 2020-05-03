import 'dart:io';

import 'package:flutter/material.dart';

import '../CloudDBWorker.dart';

class FilesList extends StatelessWidget {
  final String folderName;

  FilesList({this.folderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Expanded(
          child: StreamBuilder(
            stream: CloudDBWorker.databaseReference.collection('folders').document(folderName).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return LinearProgressIndicator();
              }
              var images = snapshot.data['images'];
              print(images);
              // return GridView.count(
              //   padding: EdgeInsets.all(10.0),
              //   primary: false,
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 10.0,
              //   mainAxisSpacing: 10.0,
              //   shrinkWrap: true,
              //   children: images.map<Widget>((image) => _buildCardItem(image)).toList(),
              // );
              return ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, image) {
                  return buildListItem(context, images[image]);
                },
              );
            },
          ),
        ),]
      ),
    );
  }

  Widget _buildCardItem(String imagePath) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ClipRRect(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Test',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ]),
      ),
    );
  }

  // List<Widget> _buildGrid(List<String> images) {
  //   return pets.map((pet) => _buildCardItem(pet, model)).toList();
  // }

  Widget buildListItem(BuildContext context, String imagePath) {
    return ListTile(
      title: Text('$imagePath'),
    );
  }
}