import 'package:flutter/material.dart';
import 'dart:io';
import 'Sqflite/media_database.dart'; // Import the database helper
import 'image_details_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> imagePaths = [];
  List<String> videoPaths = [];
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Initialize DatabaseHelper

  bool isSelectionMode = false;
  List<String> selectedPaths = [];

  @override
  void initState() {
    super.initState();
    _loadMediaFromDatabase();
  }

  Future<void> _loadMediaFromDatabase() async {
    try {
      final mediaList = await _dbHelper.getMedia();
      setState(() {
        imagePaths = mediaList
            .where((media) => media['media_type'] == 'image')
            .map<String>((media) => media['file_path'] as String)
            .toList();
        videoPaths = mediaList
            .where((media) => media['media_type'] == 'video')
            .map<String>((media) => media['file_path'] as String)
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load media: $e')),
      );
    }
  }

  void _deleteMedia(String mediaPath, String mediaType) async {
    setState(() {
      if (mediaType == 'image') {
        imagePaths.remove(mediaPath);
      } else {
        videoPaths.remove(mediaPath);
      }
    });

    try {
      final media = await _dbHelper.getMedia();
      final mediaId = media.firstWhere((item) => item['file_path'] == mediaPath)['id'];

      // Delete from the database
      await _dbHelper.deleteMedia(mediaId);

      // Delete from the local file system
      File(mediaPath).deleteSync();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete media: $e')),
      );
    }
  }

  void _deleteSelectedMedia() async {
    try {
      for (var mediaPath in selectedPaths) {
        final mediaType = imagePaths.contains(mediaPath) ? 'image' : 'video';
        final media = await _dbHelper.getMedia();
        final mediaId = media.firstWhere((item) => item['file_path'] == mediaPath)['id'];

        // Delete from the database
        await _dbHelper.deleteMedia(mediaId);

        // Delete from the local file system
        File(mediaPath).deleteSync();

        // Update UI
        setState(() {
          if (mediaType == 'image') {
            imagePaths.remove(mediaPath);
          } else {
            videoPaths.remove(mediaPath);
          }
        });
      }
      // Clear selection after deletion
      setState(() {
        selectedPaths.clear();
        isSelectionMode = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete media: $e')),
      );
    }
  }

  void _toggleSelection(String mediaPath) {
    setState(() {
      if (selectedPaths.contains(mediaPath)) {
        selectedPaths.remove(mediaPath);
        if (selectedPaths.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedPaths.add(mediaPath);
        isSelectionMode = true;
      }
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                    selectedPaths.clear();
                  });
                },
              )
            : IconButton(
                icon: Image.asset(
                  'assets/arrow.png', // Replace with your back arrow image path
                  width: 30,
                  height: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        title: Text(
          isSelectionMode
              ? '${selectedPaths.length} selected'
              : 'Gallery',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: _deleteSelectedMedia,
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: mediaPaths.length,
        itemBuilder: (context, index) {
          final media = mediaPaths[index];
          final mediaPath = media['path']!;
          final mediaType = media['type']!;

          final isSelected = selectedPaths.contains(mediaPath);

          return GestureDetector(
            onTap: () {
              if (isSelectionMode) {
                _toggleSelection(mediaPath);
              } else {
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
              }
            },
            onLongPress: () {
              _toggleSelection(mediaPath);
            },
            child: Stack(
              children: [
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: mediaType == 'image'
                        ? Image.file(
                            File(mediaPath),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.videocam,
                            size: 50,
                            color: Colors.grey,
                          ),
                    title: Text(
                      mediaPath.split('/').last, // Display the filename
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
