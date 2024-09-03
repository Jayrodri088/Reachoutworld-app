import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'gallery_screen.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  final int userId; // Add userId parameter

  const CameraScreen({super.key, required this.userId}); // Update constructor

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  bool _isFrontCamera = false;
  bool _isVideoMode = false;
  bool _isFlashOn = false;
  double _currentZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _baseScale = 1.0;
  List<String> _imagePaths = [];
  List<String> _videoPaths = [];
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
      );

      await _controller.initialize();

      _maxZoomLevel = await _controller.getMaxZoomLevel();
      _minZoomLevel = await _controller.getMinZoomLevel();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.isEmpty) {
      return;
    }

    _isFrontCamera = !_isFrontCamera;
    final camera = _isFrontCamera ? _cameras[1] : _cameras[0];

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (_isFlashOn) {
      await _controller.setFlashMode(FlashMode.off);
    } else {
      await _controller.setFlashMode(FlashMode.torch);
    }

    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _switchToVideoMode() async {
    setState(() {
      _isVideoMode = true;
    });

    if (!_isRecording) {
      await _startVideoRecording();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(imagePath);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            mediaPath: imagePath,
            mediaType: 'image',
            userId: widget.userId, // Pass userId here
            onDelete: () {
              Navigator.pop(context); // Go back to camera screen
              File(imagePath).deleteSync(); // Delete the image file
            },
            onSave: () {
              setState(() {
                _imagePaths.add(imagePath);
              });
              Navigator.pop(context); // Go back to camera screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image saved to gallery')),
              );
            },
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startVideoRecording() async {
    if (_controller.value.isRecordingVideo) {
      return;
    }

    try {
      await _initializeControllerFuture;

      await _controller.startVideoRecording();

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return;
    }

    try {
      await _initializeControllerFuture;

      final video = await _controller.stopVideoRecording();

      final directory = await getApplicationDocumentsDirectory();
      final videoPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await video.saveTo(videoPath);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            mediaPath: videoPath,
            mediaType: 'video',
            userId: widget.userId, // Pass userId here
            onDelete: () {
              Navigator.pop(context); // Go back to camera screen
              File(videoPath).deleteSync(); // Delete the video file
            },
            onSave: () {
              setState(() {
                _videoPaths.add(videoPath);
              });
              Navigator.pop(context); // Go back to camera screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video saved to gallery')),
              );
            },
          ),
        ),
      );

      setState(() {
        _isRecording = false;
        _isVideoMode = false; // Exit video mode after recording
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentZoomLevel;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    double scale = _baseScale * details.scale;
    scale = scale.clamp(_minZoomLevel, _maxZoomLevel);
    _controller.setZoomLevel(scale);
    setState(() {
      _currentZoomLevel = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              child: Stack(
                children: [
                  CameraPreview(_controller),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icon/images.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GalleryScreen(
                              
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icon/flash.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/icon/video_icon.png',
                                  width: 40,
                                  height: 40,
                                ),
                                onPressed: _switchToVideoMode,
                              ),
                              const SizedBox(width: 40), // Increased spacing
                              GestureDetector(
                                onTap: () async {
                                  if (_isVideoMode) {
                                    if (_isRecording) {
                                      await _stopVideoRecording();
                                    } else {
                                      await _startVideoRecording();
                                    }
                                  } else {
                                    await _takePicture();
                                  }
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                    color: _isRecording
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  child: _isRecording
                                      ? const Icon(Icons.stop,
                                          color: Colors.black)
                                      : Image.asset(
                                          'assets/icon/capture_img.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 40), // Increased spacing
                              IconButton(
                                icon: const Icon(
                                  Icons.switch_camera_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: _toggleCamera,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
