import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_space/controller/provider_class.dart';
import 'package:safe_space/screens/add_post.dart';
import '../constants/palette.dart';
import '../services/auth_services.dart';
import '../widgets/post_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();
  GetImageController getImageController = GetImageController();

  bool loading = false;

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  Future fetchData() async {
    setState(() {
      loading = true;
    });
    await getImageController.getPostList();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.primaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePost()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: const Icon(
          Icons.navigate_before,
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<AuthService>().signOut(context);
            },
            child: const Icon(
              MdiIcons.logout,
              color: Colors.red,
            ),
          ),
        ],
        backgroundColor: Colors.white,
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: loading == true
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: AnimatedBuilder(
                  animation: getImageController,
                  builder: (context, child) {
                    return ListView.builder(
                        itemCount: getImageController.postList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = getImageController.postList[index];
                          return PostContainer(
                            data: post,
                          );
                        });
                  }),
            ),
    ));
  }
}
