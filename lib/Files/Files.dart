import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/CloudDBWorker.dart';

import 'FilesList.dart';

class Files extends StatefulWidget {
  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Expanded(
          child: StreamBuilder(
            stream: CloudDBWorker.databaseReference.collection('folders').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return LinearProgressIndicator();
              }
              var folders = snapshot.data.documents;
              return ListView(
                children: folders.map<Widget>((folder) => buildListItem(context, folder)).toList(),
              );
            },
          ),
        ),]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
        onPressed:(){}
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    return ListTile(
      title: Text('${snapshot.reference.documentID}'),
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => FilesList(folderName: snapshot.reference.documentID))
        );
      },
    );
  }
}