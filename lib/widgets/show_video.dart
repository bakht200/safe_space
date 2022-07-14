import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:safe_space/controller/provider_class.dart';

class ShowVideo extends StatefulWidget {
  final String url;

  const ShowVideo({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late BetterPlayerController _betterPlayerController;
  GetImageController getImageController = GetImageController();

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.url);
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          showPlaceholderUntilPlay: true,
          placeholderOnTop: true,
          autoPlay: false,
          fit: BoxFit.cover,
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
          animation: getImageController,
          builder: (context, child) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController,
              ),
            );
          }),
    );
  }
}
