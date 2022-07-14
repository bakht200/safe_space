import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:safe_space/controller/provider_class.dart';

class showNetworkVideo extends StatefulWidget {
  final String url;

  const showNetworkVideo({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _showNetworkVideoState createState() => _showNetworkVideoState();
}

class _showNetworkVideoState extends State<showNetworkVideo> {
  late BetterPlayerController _betterPlayerController;
  GetImageController getImageController = GetImageController();

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);
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
