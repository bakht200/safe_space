import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_space/constants/secure_storage.dart';
import 'package:safe_space/controller/provider_class.dart';
import 'package:safe_space/widgets/profile_avatar.dart';
import 'package:safe_space/widgets/radio_button.dart';
import 'package:safe_space/widgets/responsive.dart';
import 'package:safe_space/widgets/show_network_video.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../constants/palette.dart';

class PostContainer extends StatelessWidget {
  var data;
  var userId;
  PostContainer({this.data, this.userId});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 0.0,
      ),
      elevation: 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(post: data!),
                  const SizedBox(height: 4.0),
                  Text(data!['description']),
                  data['mediaUrl']['type'] != null
                      ? SizedBox(
                          height: 200.h,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data['mediaUrl']['type'].length,
                              itemBuilder: (BuildContext context, int i) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: data['mediaUrl']['type'][i] != 'Photo'
                                      ? showNetworkVideo(
                                          url: data['mediaUrl']['url'][i])
                                      : Image.network(
                                          data['mediaUrl']['url'][i]),
                                );
                              }),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _PostStats(post: data, userId: userId),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  var post;

  _PostHeader({this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProfileAvatar(imageUrl: "https://i.stack.imgur.com/l60Hf.png"),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['userName'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${timeago.format((post['postedAt'] as Timestamp).toDate())}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostStats extends StatefulWidget {
  var post;
  var userId;

  _PostStats({this.post, this.userId});

  @override
  State<_PostStats> createState() => _PostStatsState();
}

class _PostStatsState extends State<_PostStats> {
  int _value = 1;

  GetImageController getImageController = GetImageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Palette.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thumb_up,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                "${widget.post['like'].length}",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            GetBuilder(
                init: getImageController,
                builder: (context) {
                  return _PostButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: widget.post['like'].contains(widget.userId)
                          ? Colors.blue
                          : Colors.grey[600],
                      size: 20.0,
                    ),
                    label: 'Like',
                    onTap: () async {
                      if (widget.post['like'].contains(widget.userId)) {
                        await getImageController.removePostLike(
                          widget.post['id'],
                          widget.userId,
                        );
                      } else {
                        await getImageController.getPostLike(
                          widget.post['id'],
                          widget.userId,
                        );
                      }
                      await getImageController.getPostList();
                    },
                  );
                }),
            _PostButton(
              icon: Icon(
                MdiIcons.delete,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Report',
              onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await getImageController.submitReport(
                                  widget.post['id'],
                                  widget.userId,
                                  _value,
                                  context);
                            },
                            child: const Text('Submit'),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.blue),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red)),
                        ],
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Report',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Palette.primaryColor,
                                        fontSize: 26.sp),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text('Help us to understand the problem',
                                      style: TextStyle(
                                          color: Palette.primaryColor,
                                          fontSize: 14.sp)),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0.w),
                                        child: Text('What\'s worng with this?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14.sp)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  MyRadioListTile<int>(
                                    value: 1,
                                    groupValue: _value,
                                    leading: 'A',
                                    title: Text(
                                        'Its rude, vulgar or used bad language'),
                                    onChanged: (value) =>
                                        setState(() => _value = value!),
                                  ),
                                  MyRadioListTile<int>(
                                    value: 2,
                                    groupValue: _value,
                                    leading: 'B',
                                    title: Text('Its sexually explicit'),
                                    onChanged: (value) =>
                                        setState(() => _value = value!),
                                  ),
                                  MyRadioListTile<int>(
                                    value: 3,
                                    groupValue: _value,
                                    leading: 'C',
                                    title:
                                        Text('Its harassment or hate speech'),
                                    onChanged: (value) =>
                                        setState(() => _value = value!),
                                  ),
                                  MyRadioListTile<int>(
                                    value: 4,
                                    groupValue: _value,
                                    leading: 'D',
                                    title: Text(
                                        'Its threatening,violent or suicidal'),
                                    onChanged: (value) =>
                                        setState(() => _value = value!),
                                  ),
                                ]);
                          },
                        ),
                      );
                    });
              },
            )
          ],
        ),
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final Function()? onTap;

  const _PostButton({
    Key? key,
    @required this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                const SizedBox(width: 4.0),
                Text(label!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
