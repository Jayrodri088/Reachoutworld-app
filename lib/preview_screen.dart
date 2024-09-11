import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';  // Import for Geolocator
import 'package:geocoding/geocoding.dart';    // Import for reverse geocoding
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

  // Variables to store location data
  String? _userCountry;
  String? _userState;
  String? _userCity;

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

  // Function to fetch user's location and geocode it
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Reverse geocode the location to get country, state, and city
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _userCountry = place.country;                 // Country
          _userState = place.administrativeArea;        // State or province
          _userCity = place.locality;                   // City or region
        });
        
        // Print the location to confirm it was successfully fetched
        print('Location successfully fetched: Country: $_userCountry, State: $_userState, City: $_userCity');
      } else {
        setState(() {
          _userCountry = 'Unknown';
          _userState = 'Unknown';
          _userCity = 'Unknown';
        });

        // Print in case the placemarks are empty
        print('Location not found, using defaults: Country: $_userCountry, State: $_userState, City: $_userCity');
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _userCountry = null;
        _userState = null;
        _userCity = null;
      });
    }
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

      // Get the user’s location before saving
      await _getUserLocation();

      // Save media to the local database along with location
      await _dbHelper.insertMedia(
        widget.userId,
        widget.mediaPath,
        widget.mediaType,
        _userCountry ?? 'N/A',  // Pass country, or 'N/A' if not available
        _userState ?? 'N/A',    // Pass state, or 'N/A' if not available
        _userCity ?? 'N/A'      // Pass city, or 'N/A' if not available
      );

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
