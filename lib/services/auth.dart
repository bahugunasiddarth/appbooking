import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:appbooking/services/database.dart';
import 'package:appbooking/services/shared_pref.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the current user
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        return false;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails == null) {
        throw Exception("User details are null");
      }

      // Save user details in SharedPreferences
      await _saveUserDetailsToSharedPreferences(userDetails);

      // Prepare user data for Firestore
      Map<String, dynamic> userData = {
        "Name": userDetails.displayName ?? "",
        "Email": userDetails.email ?? "",
        "Image": userDetails.photoURL ?? "",
        "Id": userDetails.uid,
      };

      // Save user data to Firestore
      await _saveUserDetailsToFirestore(context, userData, userDetails.uid);

      return true; // Sign-in successful
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, "Firebase Auth Error: ${e.message}", Colors.red);
      return false;
    } catch (e) {
      _showSnackBar(context, "Error during Google sign-in: ${e.toString()}", Colors.red);
      return false;
    }
  }

  // Save user details to SharedPreferences
  Future<void> _saveUserDetailsToSharedPreferences(User userDetails) async {
    await SharedPreferenceHelper().saveUserEmail(userDetails.email!);
    await SharedPreferenceHelper().saveUserName(userDetails.displayName!);
    await SharedPreferenceHelper().saveUserImage(userDetails.photoURL!);
    await SharedPreferenceHelper().saveUserId(userDetails.uid);
  }

  // Save user details to Firestore
  Future<void> _saveUserDetailsToFirestore(
      BuildContext context, Map<String, dynamic> userData, String userId) async {
    try {
      await DatabaseMethods().addUserDetail(userData, userId);
      _showSnackBar(context, "Registered Successfully!!!", Colors.green);
    } catch (e) {
      _showSnackBar(context, "Error saving user details: ${e.toString()}", Colors.red);
    }
  }

  // Sign out the user
  Future<bool> signOut(BuildContext context) async {
    try {
      await auth.signOut(); // Sign out from Firebase Auth
      await GoogleSignIn().signOut(); // Sign out from Google Sign-In
      await SharedPreferenceHelper().clearUserData(); // Clear user data from SharedPreferences
      return true; // Sign-out successful
    } catch (e) {
      _showSnackBar(context, "Error during sign-out: ${e.toString()}", Colors.red);
      return false;
    }
  }

  // Helper method to show a SnackBar
  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
      ),
    );
  }
}