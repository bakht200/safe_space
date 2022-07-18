import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:safe_space/constants/palette.dart';
import 'package:safe_space/screens/messaging/search.dart';
import 'package:safe_space/screens/post.dart';

import '../services/auth_services.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
            child: Stack(
              children: [
                Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    "Welcome",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                )
              ],
            ),
            decoration: const BoxDecoration(color: Colors.black)),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Profile"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.chat),
          title: const Text("Chat"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text("Posts"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalPosts()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_box),
          title: const Text("About"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () {
            context.read<AuthService>().signOut(context);
          },
        )
      ],
    );
  }
}
