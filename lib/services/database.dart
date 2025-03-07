import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Add user details to Firestore
  Future<void> addUserDetail(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // Add event details to Firestore
  Future<void> addEvent(Map<String, dynamic> eventInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .set(eventInfoMap);
  }

  // Get all events as a stream
  Stream<QuerySnapshot> getAllEvents() {
    return FirebaseFirestore.instance.collection("events").snapshots();
  }

  // Get all events as a future (for one-time fetch)
  Future<QuerySnapshot> getEventsOnce() async {
    return FirebaseFirestore.instance.collection("events").get();
  }

  // Add user booking
  Future<void> addUserBooking(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .add(userInfoMap);
  }

  // Add admin tickets
  Future<void> addAdminTickets(Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance.collection("Tickets").add(userInfoMap);
  }

  Future<QuerySnapshot> getEventsByCategory(String category) async {
    return await FirebaseFirestore.instance
        .collection("events")
        .where("category", isEqualTo: category)
        .where(
          "date",
          isGreaterThanOrEqualTo: DateTime.now().toIso8601String(),
        ) 
        .get();
  }

  Future<QuerySnapshot> getUserPurchasedTickets(String userId) async {
    return await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("Booking")
      .get();
}
}
