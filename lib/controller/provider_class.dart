import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImageController with ChangeNotifier {
  List<File>? files;

  File? video;
  final picker = ImagePicker();
  List postList = [];

  selectImages() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }
    notifyListeners();
  }

  removeSelectedImage(index) async {
    files!.removeWhere((element) => element == files![index]);
    notifyListeners();
  }

  selectVideos() async {
    XFile? pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      video = File(pickedFile.path);
    }
    notifyListeners();
  }

  getPostList() async {
    List post = [];

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          post.add(element);
        });
      });

      postList = post;
      notifyListeners();
      return postList;
    } catch (e) {
      return null;
    }
  }
}
