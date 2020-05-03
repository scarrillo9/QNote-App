import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDBWorker {

  static final databaseReference = Firestore.instance;
  List<dynamic> imagePaths = List<dynamic>();
  List<dynamic> folders = List<dynamic>();
  Map<String, List<dynamic>> map = Map<String, List<dynamic>>();

  CloudDBWorker();

  void createMap() async {
    await databaseReference.collection('folders').getDocuments().then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => map.putIfAbsent(f.documentID, () => f.data['images']));
      }
    );
  }

  void getFolders() {
    databaseReference.collection('folders').getDocuments().then(
      (QuerySnapshot snapshot) {
        // snapshot.documents.forEach((f) => folders.add('${f.documentID}'));
        snapshot.documents.forEach((f) => print('Doc data: ${f.data}'));
        snapshot.documents.forEach((f) => folders.add(f.documentID));
        print(folders[0]);
        print(folders.length);
      }
    );
  }

  void getImagesFromCloud() {
    databaseReference.collection('folders').document('test').get().then((v) => imagePaths = v.data["images"]);
  }

  void saveInCloud(String folder) async {
    try {
      await databaseReference
          .collection('folders')
          .document(folder)
          .setData({
        'images': imagePaths,
      });
    } catch (e) {
      print(e);
    }
    print('Successfully Uploaded to Cloud');
  }
}