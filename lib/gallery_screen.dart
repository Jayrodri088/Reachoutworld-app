import 'package:flutter/material.dart';
import 'dart:io';
import 'image_details_screen.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> videoPaths;

  const GalleryScreen({
    Key? key,
    required this.imagePaths,
    required this.videoPaths,
  }) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> imagePaths = [];
  List<String> videoPaths = [];

  @override
  void initState() {
    super.initState();
    imagePaths = widget.imagePaths;
    videoPaths = widget.videoPaths;
  }

  void _deleteMedia(String mediaPath, String mediaType) {
    setState(() {
      if (mediaType == 'image') {
        imagePaths.remove(mediaPath);
      } else {
        videoPaths.remove(mediaPath);
      }
    });
    File(mediaPath).deleteSync();
  }

  void _saveEditedImage(String editedImagePath) {
    setState(() {
      imagePaths.add(editedImagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaPaths = [
      ...imagePaths.map((path) => {'path': path, 'type': 'image'}),
      ...videoPaths.map((path) => {'path': path, 'type': 'video'}),
    ];

    return Scaffold(
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
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/settings_1.png', // Replace with your settings image path
              width: 30,
              height: 30,
            ),
            onPressed: () {
              // Handle settings icon press
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: mediaPaths.length,
        itemBuilder: (context, index) {
          final media = mediaPaths[index];
          final mediaPath = media['path']!;
          final mediaType = media['type']!;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDetailsScreen(
                    mediaPath: mediaPath,
                    mediaType: mediaType,
                    onDelete: () {
                      _deleteMedia(mediaPath, mediaType);
                    },
                    onSave: (editedImagePath) {
                      _saveEditedImage(editedImagePath);
                    },
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mediaType == 'image'
                    ? Image.file(
                        File(mediaPath),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.videocam,
                        size: 80,
                        color: Colors.grey,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
