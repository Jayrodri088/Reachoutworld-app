import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'Sqflite/media_database.dart'; // Import the database helper

class PreviewScreen extends StatefulWidget {
  final String mediaPath;
  final String mediaType;
  final int userId;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const PreviewScreen({
    Key? key,
    required this.mediaPath,
    required this.mediaType,
    required this.userId,
    required this.onDelete,
    required this.onSave,
  }) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController _videoController;
  final DatabaseHelper _dbHelper = DatabaseHelper(); 
  bool _isVideoInitialized = false;
  bool _isSaving = false; 

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
            _videoController.play();
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load video: $error')),
          );
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

  Future<void> _saveMedia() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Ensure the media file exists before attempting to save
      if (!File(widget.mediaPath).existsSync()) {
        throw Exception("Media file not found");
      }

      if (widget.mediaType == 'video' && _videoController.value.isPlaying) {
        _videoController.pause();
      }

      // Start the save operation
      await _dbHelper.insertMedia(widget.userId, widget.mediaPath, widget.mediaType);
      widget.onSave();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save media: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
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
                : _isVideoInitialized
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
                ),
                iconSize: 20,
                onPressed: _isSaving ? null : widget.onDelete, 
              ),
              IconButton(
                icon: _isSaving
                    ? const CircularProgressIndicator()
                    : Image.asset(
                        'assets/icon/save.png',
                        height: 80,
                        width: 80,
                      ),
                iconSize: 20,
                onPressed: _isSaving ? null : _saveMedia,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
