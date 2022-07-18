import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:safe_space/constants/data.dart';
import 'package:safe_space/constants/secure_storage.dart';
import 'package:safe_space/controller/provider_class.dart';
import 'package:safe_space/screens/screens.dart';
import 'package:safe_space/widgets/show_video.dart';
import '../constants/palette.dart';
import '../services/auth_services.dart';
import '../widgets/profile_avatar.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  GetImageController getImageController = GetImageController();
  TextEditingController descriptionController = TextEditingController();

  final imageArray = <String>[];
  String? userName;

  @override
  void initState() {
    fetchCurrentUserName();
    // TODO: implement initState
    super.initState();
  }

  fetchCurrentUserName() async {
    userName = await UserSecureStorage.fetchUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Palette.primaryColor,
                ),
                onPressed: () async {
                  if (getImageController.files == null) {
                    await getImageController.insertPost(null, "subjectname",
                        descriptionController.text, context);
                  } else {
                    await getImageController.insertPost(
                        getImageController.files,
                        "subjectname",
                        descriptionController.text,
                        context);
                  }

                  imageArray.clear();
                },
                child: const Text('Post')),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Safe Space',
          style: TextStyle(
            color: Palette.primaryColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Row(
                children: [
                  ProfileAvatar(imageUrl: currentUser.imageUrl),
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: Text(
                      "$userName",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                height: 250.h,
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'What\'s on your mind?',
                  ),
                ),
              ),
              AnimatedBuilder(
                  animation: getImageController,
                  builder: (context, child) {
                    return SizedBox(
                      height: 250.h,
                      child: getImageController.files != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedBuilder(
                                  animation: getImageController,
                                  builder: (context, child) {
                                    return GridView.builder(
                                        itemCount:
                                            getImageController.files!.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onLongPress: () {
                                              getImageController
                                                  .removeSelectedImage(index);
                                            },
                                            child: getImageController
                                                    .files![index].path
                                                    .contains('mp4')
                                                ? ShowVideo(
                                                    url: getImageController
                                                        .files![index].path)
                                                : Image.file(
                                                    File(getImageController
                                                        .files![index].path),
                                                    fit: BoxFit.cover),
                                          );
                                        });
                                  }))
                          : const SizedBox(),
                    );
                  }),
              Divider(height: 10.0.h, thickness: 0.5),
              SizedBox(
                height: 30.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton.icon(
                      onPressed: () {
                        getImageController.selectImages();
                      },
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                      label: const Text('Gallery'),
                    ),
                    VerticalDivider(width: 8.0.w),
                    FlatButton.icon(
                      onPressed: () => print('Room'),
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.purpleAccent,
                      ),
                      label: const Text('Audio'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
