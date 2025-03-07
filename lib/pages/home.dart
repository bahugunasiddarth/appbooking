import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbooking/services/database.dart';
import 'package:appbooking/pages/detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List of categories with icons & labels
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.music_note, "label": "Music"},
    {"icon": Icons.checkroom, "label": "Clothing"},
    {"icon": Icons.festival, "label": "Festival"},
    {"icon": Icons.sports_soccer, "label": "Sports"},
    {"icon": Icons.theater_comedy, "label": "Theater"},
  ];

  // List of upcoming events (fetched from Firestore)
  List<Map<String, dynamic>> upcomingEvents = [];

  // Instance of DatabaseMethods
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Fetch events from Firestore and filter out past events
  Future<void> fetchEvents() async {
    try {
      final QuerySnapshot snapshot = await databaseMethods.getEventsOnce();
      print("Fetched ${snapshot.docs.length} events");
      final now = DateTime.now();

      setState(() {
        upcomingEvents =
            snapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    "date": data["date"] ?? "No date",
                    "title": data["name"] ?? "No title",
                    "price": data["price"] != null ? "\$${data["price"]}" : "Free",
                    "location": data["location"] ?? "Location not available",
                    "image": "images/1.jpg",
                  };
                })
                .where((event) {
                  // Filter out events that have passed
                  final eventDate = DateTime.parse(event["date"]);
                  return eventDate.isAfter(now);
                })
                .toList();
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👋 Greeting and Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Add extra space from the top
                  const SizedBox(height: 40),

                  /// Greeting Section with better styling
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26, // Increased font size for a better heading
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: "Hello, ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextSpan(
                          text: "Siddharth",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w900, // More emphasis on name
                          ),
                        ),
                        const TextSpan(
                          text: " 👋", // Friendly emoji for a welcoming feel
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12), // Better spacing

                  /// Location Section
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.redAccent, // More noticeable
                        size: 24.0, // Slightly larger icon
                      ),
                      const SizedBox(width: 8.0), // More spacing
                      Text(
                        "Noida, India",
                        style: TextStyle(
                          fontSize: 18, // Slightly larger for better readability
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          letterSpacing: 0.5, // Subtle letter spacing for elegance
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25), // Extra spacing before next content
                ],
              ),

              /// 🎉 Event Count
              Text(
                "There are (${upcomingEvents.length}) events around your location.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),

              const SizedBox(height: 20.0),

              /// 🔍 **Search Bar**
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search an Event",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 2),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30.0),

              /// 🎭 **Category List (Horizontal Scroll)**
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 12.0,
                        right: index == categories.length - 1 ? 0 : 12.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          // Handle category tap
                        },
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(15.0),
                          shadowColor: Colors.black12,
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade50, Colors.white],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  categories[index]["icon"],
                                  size: 32,
                                  color: Colors.blue.shade900,
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    categories[index]["label"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30.0),

              /// **Upcoming Events Section**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upcoming Events",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "See All" button press
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              /// 🎟️ **Event Cards**
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with Date Overlay
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            // Event Image
                            InkWell(
                              onTap: () {
                                // Navigate to the detail page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailPage(event: event),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                child: Image.asset(
                                  event["image"],
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // Date Overlay
                            Container(
                              margin: const EdgeInsets.all(12.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                event["date"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Event Details (Title, Location, Price)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Event Title
                              Text(
                                event["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),

                              // Event Location
                              Text(
                                event["location"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8.0),

                              // Event Price
                              Text(
                                event["price"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
