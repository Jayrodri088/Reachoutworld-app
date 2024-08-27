import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Wallet',
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
