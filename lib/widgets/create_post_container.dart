import 'package:flutter/material.dart';
import 'package:safe_space/widgets/profile_avatar.dart';
import 'package:safe_space/widgets/responsive.dart';

import '../models/user_model.dart';

class CreatePostContainer extends StatelessWidget {
  final User? currentUser;

  const CreatePostContainer({
    Key? key,
    @required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  ProfileAvatar(imageUrl: currentUser!.imageUrl),
                  const SizedBox(width: 8.0),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'What\'s on your mind?',
                      ),
                    ),
                  )
                ],
              ),
              const Divider(height: 10.0, thickness: 0.5),
              SizedBox(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton.icon(
                      onPressed: () => print('Live'),
                      icon: const Icon(
                        Icons.videocam,
                        color: Colors.red,
                      ),
                      label: const Text('Live'),
                    ),
                    const VerticalDivider(width: 8.0),
                    FlatButton.icon(
                      onPressed: () => print('Photo'),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                      label: const Text('Photo'),
                    ),
                    const VerticalDivider(width: 8.0),
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
