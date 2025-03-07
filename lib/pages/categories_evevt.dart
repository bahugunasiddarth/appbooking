import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbooking/services/database.dart';

class CategoriesEvent extends StatefulWidget {
  final String category;

  const CategoriesEvent({super.key, required this.category});

  @override
  State<CategoriesEvent> createState() => _CategoriesEventState();
}

class _CategoriesEventState extends State<CategoriesEvent> {
  List<Map<String, dynamic>> categoryEvents = [];
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    fetchCategoryEvents();
  }

  Future<void> fetchCategoryEvents() async {
    try {
      final QuerySnapshot snapshot = await databaseMethods.getEventsByCategory(widget.category);
      final now = DateTime.now();

      setState(() {
        categoryEvents = snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};
              final dateStr = data["date"] ?? "";
              DateTime? eventDate;
              
              try {
                eventDate = DateTime.parse(dateStr);
              } catch (_) {
                eventDate = null;
              }

              return {
                "date": eventDate,
                "title": data["name"] ?? "No title",
                "price": data["price"] ?? "Free",
                "location": data["location"] ?? "Location not available",
                "image": data["image"] ?? "images/default.jpg",
              };
            })
            .where((event) => event["date"] != null && event["date"].isAfter(now))
            .toList();
      });
    } catch (e) {
      print("Error fetching category events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: categoryEvents.isEmpty
          ? const Center(child: Text("No events found for this category."))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categoryEvents.length,
              itemBuilder: (context, index) {
                final event = categoryEvents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: event["image"].startsWith("http")
                        ? Image.network(event["image"], width: 50, height: 50, fit: BoxFit.cover)
                        : Image.asset(event["image"], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(event["title"]),
                    subtitle: Text(event["location"]),
                    trailing: Text(event["price"]),
                    onTap: () {
                      // Implement navigation to event detail page
                    },
                  ),
                );
              },
            ),
    );
  }
}
