import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_space/constants/secure_storage.dart';
import 'package:safe_space/controller/provider_class.dart';
import 'package:safe_space/screens/login.dart';

import '../screens/home_screen.dart';

class AuthService {
  late final FirebaseAuth firebaseAuth;

  AuthService(this.firebaseAuth);

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();
  GetImageController getImageController = GetImageController();

  login(String email, String password, context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;

      await UserSecureStorage.setToken(user!.uid);

      String? id = await UserSecureStorage.fetchToken();

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();
      await UserSecureStorage.setUserName(snapshot.docs[0]['firstName']);
      String? name = await UserSecureStorage.fetchUserName();

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      return "LogedIn";
    } catch (e) {
      return e;
    }
  }

  signUp(String email, String password, context) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;

      await UserSecureStorage.setToken(user!.uid);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();
      await UserSecureStorage.setUserName(snapshot.docs[0]['firstName']);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      return "SignedUp";
    } catch (e) {
      return e;
    }
  }

  signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await UserSecureStorage.deleteSecureStorage();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      return "logout";
    } catch (e) {
      return e;
    }
  }

  // Future uploadVideo(String? file, String subjectname, fileType,
  //     descriptionController, context) async {
  //   try {
  //     String? url;
  //     User? user = FirebaseAuth.instance.currentUser;

  //     final path = firebaseStorage.FirebaseStorage.instance
  //         .ref("safespace/$subjectname${user!.uid}");

  //     final child = path.child("$fileType}");
  //     await child.putFile(File(file!));
  //     await child.getDownloadURL().then((value) => {url = value});
  //     String? userName = await UserSecureStorage.fetchUserName();

  //     await FirebaseFirestore.instance
  //         .collection("posts")
  //         .doc(user.tenantId)
  //         .set({
  //       'postedBy': user.uid,
  //       'userName': userName,
  //       'fileType': fileType,
  //       'mediaUrl': url,
  //       'likes': 0,
  //       'postedAt': DateTime.now(),
  //       'description': descriptionController,
  //     });
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => HomeScreen()));

  //     return url;
  //   } on FirebaseException catch (e) {
  //     rethrow;
  //   }
  // }
}
