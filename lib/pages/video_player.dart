import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..addListener(_videoListener)
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController,
                autoPlay: true,
                allowPlaybackSpeedChanging: true,
                looping: false,
                aspectRatio: _videoPlayerController.value.aspectRatio,
                allowedScreenSleep: false,
                showControlsOnInitialize: true,
                materialSeekButtonFadeDuration:
                    const Duration(milliseconds: 100),
                materialSeekButtonSize: 30,
                hideControlsTimer: const Duration(seconds: 2),
                autoInitialize: true,
                draggableProgressBar: true,
                materialProgressColors: ChewieProgressColors(
                  playedColor: Colors.red,
                  handleColor: Colors.white,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              );
            });
          });
  }

  void _videoListener() {
    if (!mounted) return;

    final isBuffering = _videoPlayerController.value.isBuffering;
    if (isBuffering != _isBuffering) {
      setState(() {
        _isBuffering = isBuffering;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_videoListener);
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized =
        _chewieController?.videoPlayerController.value.isInitialized ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Center(
        child: isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Chewie(controller: _chewieController!),
                  if (_isBuffering)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
