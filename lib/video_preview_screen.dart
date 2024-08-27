import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const VideoPreviewScreen({
    Key? key,
    required this.videoPath,
    required this.onDelete,
    required this.onSave,
  }) : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              icon: Image.asset('assets/icon/cancel_img.png', height: 80, width: 80), // First button image
              iconSize: 20,
              onPressed: widget.onDelete,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: Image.asset('assets/icon/save.png', height: 80, width: 80), // Second button image
              iconSize: 20,
              onPressed: widget.onSave,
            ),
          ),
        ],
      ),
    );
  }
}
