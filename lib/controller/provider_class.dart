import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_space/services/helper_functions.dart';
import '../screens/home_screen.dart';
import 'dart:convert';

class GetImageController extends GetxController {
  List<File>? files;
  final picker = ImagePicker();
  List postList = [];
  List personalPost = [];

  HelperFunction helperFunction = HelperFunction();
  var loader = false;

  setLoader() {
    if (loader == false) {
      loader = true;
    } else {
      loader = false;
    }
    update();
  }

  selectImages() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }
    update();
  }

  removeSelectedImage(index) async {
    files!.removeWhere((element) => element == files![index]);
    update();
  }

  insertPost(file, subjectname, descriptionController, context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    var response = await helperFunction.uploadFile(
        file, subjectname, descriptionController);

    if (response == "filedUploaded") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Post Added.");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => HomeScreen()));
    }
  }

  getPostList() async {
    var response = await helperFunction.getpostList();
    if (response != null) {
      postList = response;
    }
  }

  getPersonalPost() async {
    var response = await helperFunction.getpostList();
    if (response != null) {
      personalPost = response;
    }
  }

  getPostLike(id, userId) async {
    var response = await helperFunction.likepost(id, userId);
    if (response == "Updated") {
      getPostList();
    }
    update();
  }

  removePostLike(id, userId) async {
    var response = await helperFunction.unLikePost(id, userId);
    if (response == "Updated") {
      getPostList();
    }
    update();
  }

  submitReport(id, userId, report, context) async {
    var response = await helperFunction.report(id, userId, report);
    if (response == "Reported") {
      getPostList();
      Fluttertoast.showToast(msg: "Report Added.");
      Navigator.pop(context);
    }
    update();
  }
}
