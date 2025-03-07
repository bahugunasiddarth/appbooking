import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbooking/services/database.dart';

class TicketEvent extends StatefulWidget {
  final String userId;

  const TicketEvent({super.key, required this.userId});

  @override
  State<TicketEvent> createState() => _TicketEventState();
}

class _TicketEventState extends State<TicketEvent> {
  List<Map<String, dynamic>> purchasedTickets = [];
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    fetchPurchasedTickets();
  }

  // Fetch purchased tickets for the user
  Future<void> fetchPurchasedTickets() async {
    try {
      final QuerySnapshot snapshot = await databaseMethods.getUserPurchasedTickets(widget.userId);

      setState(() {
        purchasedTickets = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            "eventName": data["eventName"] ?? "No event name",
            "date": data["date"] ?? "No date",
            "price": data["price"] ?? "Free",
            "location": data["location"] ?? "Location not available",
            "ticketId": doc.id, // Unique ticket ID
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching purchased tickets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tickets"),
      ),
      body: purchasedTickets.isEmpty
          ? const Center(child: Text("No tickets purchased yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: purchasedTickets.length,
              itemBuilder: (context, index) {
                final ticket = purchasedTickets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(ticket["eventName"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${ticket["date"]}"),
                        Text("Location: ${ticket["location"]}"),
                        Text("Price: ${ticket["price"]}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Optionally, add functionality to delete/cancel the ticket
                        _deleteTicket(ticket["ticketId"]);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Function to delete a ticket
  Future<void> _deleteTicket(String ticketId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("Booking")
          .doc(ticketId)
          .delete();

      // Refresh the list after deletion
      fetchPurchasedTickets();
    } catch (e) {
      print("Error deleting ticket: $e");
    }
  }
}