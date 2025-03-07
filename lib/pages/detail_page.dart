import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appbooking/services/database.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const DetailPage({super.key, required this.event});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int ticketCount = 1;
  final int ticketPrice = 150;
  final DatabaseMethods _databaseMethods =
  DatabaseMethods(); // Instance of DatabaseMethods

  void _bookNow() async {
    // Get the current user ID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You must be logged in to book tickets."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create a map with the booking details
    Map<String, dynamic> bookingDetails = {
      "eventTitle": widget.event["title"],
      "eventDate": widget.event["date"],
      "eventLocation": widget.event["location"],
      "ticketCount": ticketCount,
      "totalAmount": ticketCount * ticketPrice,
      "bookingTime": DateTime.now(),
    };

    // Add the booking details to Firestore
    await _databaseMethods.addUserBooking(bookingDetails, userId);

    // Show a green popup message
    showDialog(
      context: context,
      builder:
          (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Checkmark Icon
                Icon(Icons.check_circle, color: Colors.white, size: 60),
                SizedBox(height: 15),

                // Ticket Booked Text
                Text(
                  'Ticket Booked!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 10),

                // Additional Details
                Text(
                  '${widget.event["title"]}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  '$ticketCount Ticket(s)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Optionally, close the dialog after a few seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              // Background Image
              Container(
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.event["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient Overlay for Better Readability
              Container(
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: 40,
                left: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),

              // Event Details (Title, Date, Location)
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event["title"], // Use event title
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 5),
                        Text(
                          widget.event["date"], // Use event date
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 5),
                        Text(
                          widget.event["location"], // Use event location
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Event Description & Ticket Counter
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Experience an electrifying night performing live! "
                        "Enjoy an unforgettable musical journey with stunning visuals and high-energy beats.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),

                  // Ticket Counter Section
                  Text(
                    "Number of Tickets",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Decrease Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (ticketCount > 1) ticketCount--;
                          });
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color:
                            ticketCount > 1
                                ? Colors.blue
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 15),

                      // Ticket Count
                      Text(
                        "$ticketCount",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 15),

                      // Increase Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            ticketCount++;
                          });
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar (Amount & Book Now Button)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Amount
                Text(
                  "Amount: \$${ticketCount * ticketPrice}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                // Book Now Button
                ElevatedButton(
                  onPressed: _bookNow, // Call the _bookNow method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    elevation: 3,
                  ),
                  child: Text(
                    "Book Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}