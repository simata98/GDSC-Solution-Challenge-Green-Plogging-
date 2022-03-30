import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'map_model.dart';

class UploadImage {
  static String mapUrl = '';

  static void uploadFile() async {
    if (!MapModel.to.isClosed) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child('post_images')
          .child('_view_' + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(MapModel.to.viewImage!);
      uploadTask.then((res) async {
        mapUrl = await res.ref.getDownloadURL();
      });

      var fileName = "${DateTime.now()}.jpg";
      var tempDir = (await getTemporaryDirectory()).path;
      Uint8List? tmp = await MapModel.to.mapController?.takeSnapshot();
      File? imageFile = await File('$tempDir/$fileName').writeAsBytes(tmp!);
      Reference ref1 = storage
          .ref()
          .child('post_images')
          .child('_map_' + DateTime.now().toString());
      UploadTask uploadTask1 = ref1.putFile(imageFile);
      uploadTask1.then((res) async {
        print(await res.ref.getDownloadURL());
      });
    } else {
      print('MapModel is Closed!!');
    }
  }
}
