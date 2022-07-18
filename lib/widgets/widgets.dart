export 'circle_button.dart';
export 'create_post_container.dart';
export 'rooms.dart';
export 'profile_avatar.dart';
export 'stories.dart';
export 'post_container.dart';
export 'custom_tab_bar.dart';
export 'responsive.dart';
export 'custom_app_bar.dart';
export 'user_card.dart';
export 'contacts_list.dart';
export 'more_options_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Logo'),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.black, fontSize: 17);
}
