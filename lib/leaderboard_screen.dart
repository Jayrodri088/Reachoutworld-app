import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Container(
            color: Colors.white, // Set the background color here
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/arrow.png', // Replace with your back arrow image path
                    width: 30,
                    height: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
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
            
          ),
          const Spacer(),
          const Text(
            'COMING SOON',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white, // Set the same background color as header
            ),
          ),
        ],
      ),
    );
  }
}
