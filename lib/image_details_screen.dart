import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // For date formatting
import 'package:path_provider/path_provider.dart'; // For accessing the device's file system
import 'package:video_player/video_player.dart';

class ImageDetailsScreen extends StatefulWidget {
  final String mediaPath;
  final String mediaType;
  final VoidCallback onDelete;
  final ValueChanged<String> onSave;

  const ImageDetailsScreen({
    super.key,
    required this.mediaPath,
    required this.mediaType,
    required this.onDelete,
    required this.onSave,
  });

  @override
  _ImageDetailsScreenState createState() => _ImageDetailsScreenState();
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
  late File _mediaFile;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _mediaFile = File(widget.mediaPath);

    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.file(_mediaFile)
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

  Future<void> _saveEditedImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final editedImagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_edited.jpg';
    _mediaFile.copySync(editedImagePath);

    widget.onSave(editedImagePath);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved successfully')),
    );

    Navigator.of(context).pop(); // Go back to gallery screen
  }

  @override
  Widget build(BuildContext context) {
    final file = _mediaFile;
    final fileStat = file.statSync();
    final creationDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(fileStat.changed);
    final fileName = file.uri.pathSegments.last;
    final fileSize = (fileStat.size / 1024).toStringAsFixed(2); // size in KB

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/arrow.png', // Replace with your back arrow image path
            width: 30,
            height: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Media Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50), // Add padding to the top
          Expanded(
            child: widget.mediaType == 'image'
                ? Image.file(_mediaFile)
                : _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : const CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text(
            'Name: $fileName',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            'Size: $fileSize KB',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            'Created: $creationDate',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icon/delete.png',
                      height: 40,
                      width: 40,
                    ),
                    iconSize: 20,
                    onPressed: () {
                      widget.onDelete();
                      Navigator.pop(
                          context); // Close the details screen after deleting
                    },
                  ),
                  const Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icon/save_1.png',
                      height: 40,
                      width: 40,
                    ),
                    iconSize: 20,
                    onPressed: _saveEditedImage,
                  ),
                  const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
