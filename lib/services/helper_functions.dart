import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_space/constants/secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class HelperFunction {
  Future uploadFile(
    List<File>? file,
    String subjectname,
    descriptionController,
  ) async {
    try {
      if (file == null) {
        User? user = FirebaseAuth.instance.currentUser;

        String? userName = await UserSecureStorage.fetchUserName();
        var uniqueId = FirebaseFirestore.instance.collection("posts").doc().id;

        await FirebaseFirestore.instance.collection("posts").doc(uniqueId).set({
          'postedBy': user!.uid,
          'userName': userName,
          'mediaUrl': {'type': null, 'url': null},
          'like': [],
          'report': [],
          'postedAt': DateTime.now(),
          'description': descriptionController,
          'id': uniqueId
        });
      } else {
        List<String> url = [];
        List<String> mediaType = [];

        User? user = FirebaseAuth.instance.currentUser;

        final path = firebaseStorage.FirebaseStorage.instance
            .ref("safespace/$subjectname${user!.uid}");

        for (var i = 0; i < file.length; i++) {
          if (file[i].path.contains('mp4')) {
            mediaType.add('Video');
          } else {
            mediaType.add('Photo');
          }
          final child = path.child(DateTime.now().toString());
          await child.putFile(File(file[i].path));
          await child.getDownloadURL().then((value) => {url.add(value)});
        }

        String? userName = await UserSecureStorage.fetchUserName();
        var uniqueId = FirebaseFirestore.instance.collection("posts").doc().id;

        await FirebaseFirestore.instance.collection("posts").doc(uniqueId).set({
          'postedBy': user.uid,
          'userName': userName,
          'mediaUrl': {'type': mediaType, 'url': url},
          'like': [],
          'report': [],
          'postedAt': DateTime.now(),
          'description': descriptionController,
          'id': uniqueId
        });
      }
      return "filedUploaded";
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  getpostList() async {
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

      return post;
    } catch (e) {
      return null;
    }
  }

  getPersonalPostList() async {
    List post = [];

    try {
      String? userId = await UserSecureStorage.fetchToken();

      await FirebaseFirestore.instance
          .collection('users')
          .where('postedBy', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          post.add(element);
        });
      });

      return post;
    } catch (e) {
      return null;
    }
  }

  likepost(id, userId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(id).update({
        "like": FieldValue.arrayUnion([userId])
      });
      return "Updated";
    } catch (e) {
      return null;
    }
  }

  unLikePost(id, userId) async {
    try {
      final equipmentCollection =
          FirebaseFirestore.instance.collection("posts").doc(id);

      final docSnap = await equipmentCollection.get();

      List queue = docSnap.get('like');

      if (queue.contains(userId) == true) {
        equipmentCollection.update({
          "like": FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      return null;
    }
  }

  report(id, userId, report) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(id).update({
        "report": FieldValue.arrayUnion([
          {
            'userId': userId,
            'reportedText': report == 1
                ? 'rude'
                : report == 2
                    ? 'sexually'
                    : report == 3
                        ? 'harassment'
                        : 'threatning'
          }
        ])
      });
      return "Reported";
    } catch (e) {
      return null;
    }
  }
}
