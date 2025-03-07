import 'package:flutter/material.dart';

class Boooking extends StatelessWidget {
  const Boooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        title: const Text(
          'Bookings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Increased font size
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Increased padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue, size: 26), // Increased icon size
                SizedBox(width: 8),
                Text(
                  'Delhi, India',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), // Increased font size
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white, // Explicitly setting the box color to white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Increased border radius
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Increased padding inside the box
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Karan Aujla Concert',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Increased font size
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: Colors.blue), // Increased icon size
                        SizedBox(width: 8),
                        Text('2025-06-21', style: TextStyle(fontSize: 18)), // Increased font size
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.people, size: 20, color: Colors.blue), // Increased icon size
                        SizedBox(width: 8),
                        Text('3', style: TextStyle(fontSize: 18)), // Increased font size
                        SizedBox(width: 16),
                        Icon(Icons.attach_money, size: 20, color: Colors.blue), // Increased icon size
                        SizedBox(width: 8),
                        Text('\$450', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), // Increased font size
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
