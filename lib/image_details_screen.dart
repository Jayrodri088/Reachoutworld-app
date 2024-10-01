import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for Font Awesome icons
import 'dart:io';
import 'package:share_plus/share_plus.dart'; // Import for share_plus
import 'package:social_share/social_share.dart'; // Import for social_share
import 'package:intl/intl.dart'; // For date formatting
// import 'package:path_provider/path_provider.dart'; // For accessing the device's file system
import 'package:video_player/video_player.dart';

class ImageDetailsScreen extends StatefulWidget {
  final String mediaPath; // This is the file path used for sharing
  final String mediaType;
  final VoidCallback onDelete;
  final ValueChanged<String> onSave; // We will reuse this for sharing

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
  late File _mediaFile; // The actual file
  late VideoPlayerController _videoController;
  final String _hashtags = "#Flutter #MediaSharing #SocialApp";

  @override
  void initState() {
    super.initState();
    _mediaFile = File(widget.mediaPath); // Set the file path

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

  // This function opens the bottom sheet for sharing options
  Future<void> _openShareOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.blue), // Facebook icon
                        iconSize: 40,
                        onPressed: () {
                          SocialShare.shareFacebookStory(
                            imagePath:
                                widget.mediaPath, // Use the correct media path
                            backgroundTopColor: "#ffffff",
                            backgroundBottomColor: "#000000",
                            attributionURL: "https://flutter.dev",
                            appId:
                                "1589353818318673", // Replace with actual Facebook App ID
                          ).then((data) {
                            print("Shared to Facebook: $data");
                            Navigator.pop(context); // Close after sharing
                          }).catchError((error) {
                            print("Error: $error");
                          });
                        },
                      ),
                      const Text('Facebook'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.instagram,
                            color: const Color.fromARGB(255, 176, 39, 50)), // Instagram icon
                        iconSize: 40,
                        onPressed: () {
                          SocialShare.shareInstagramStory(
                            imagePath:
                                widget.mediaPath, // Use the correct media path
                            backgroundTopColor: "#ffffff",
                            backgroundBottomColor: "#000000",
                            attributionURL: "https://flutter.dev",
                            appId: "563769332663383",
                          ).then((data) {
                            print("Shared to Instagram: $data");
                            Navigator.pop(context); // Close after sharing
                          }).catchError((error) {
                            print("Error: $error");
                          });
                        },
                      ),
                      const Text('Instagram'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.shareNodes,
                            color: Colors.black), // Default share icon
                        iconSize: 30,
                        onPressed: () {
                          Share.shareXFiles(
                            [
                              XFile(widget.mediaPath)
                            ], // This replaces shareFiles with shareXFiles
                            text: 'Check out this media! $_hashtags',
                          );
                          Navigator.pop(context); // Close after sharing
                        },
                      ),
                      const Text('Share'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
            'assets/arrow.png', // Your back arrow image
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
                    icon: FaIcon(FontAwesomeIcons.trash,
                        color: Colors.blue), // Trash icon
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
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.shareNodes,
                        color: Colors.blue), // Share icon
                    iconSize: 20,
                    onPressed:
                        _openShareOptions, // Open the share options when clicked
                  ),
                  const Text(
                    'Share', // Change label to "Share"
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
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
