import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {

  final String youtubeId;
  const YoutubePlayerWidget({super.key, required this.youtubeId});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {

  late YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.youtubeId ,
        flags: const YoutubePlayerFlags(
            hideThumbnail: true,
            showLiveFullscreenButton: false,
            mute: false,
            autoPlay: false,
            disableDragSeek: true,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false
        ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
       controller: _controller!,
       showVideoProgressIndicator: true,
    );
  }
}