import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final String mediaPath;
  final String mediaType;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const PreviewScreen({
    Key? key,
    required this.mediaPath,
    required this.mediaType,
    required this.onDelete,
    required this.onSave,
  }) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {});
          _videoController.play();
        });
    }
  }

  @override
  void dispose() {
    if (widget.mediaType == 'video') {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: widget.mediaType == 'image'
                ? Image.file(File(widget.mediaPath))
                : _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : const CircularProgressIndicator(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icon/cancel_img.png',
                  height: 80,
                  width: 80,
                ), // First button image
                iconSize: 20,
                onPressed: widget.onDelete,
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon/save.png',
                  height: 80,
                  width: 80,
                ), // Second button image
                iconSize: 20,
                onPressed: widget.onSave,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
