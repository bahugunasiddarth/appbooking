import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadEvent(),
      theme: ThemeData(primarySwatch: Colors.blue),
    ),
  );
}

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  _UploadEventState createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController locationController =TextEditingController(); 
  
  // Dropdown Categories
  final List<String> _categories = [
    "Music",
    "Food",
    "Clothing",
    "Festival",
    "Sports",
    "Theater",
  ];
  String? _selectedCategory;

  // Date & Time Pickers
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Image Picker
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Select Date
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Select Time
  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Select Image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload Event (Without Firebase Image Upload)
  Future<void> uploadEvent() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        _selectedImage != null &&
        locationController.text.isNotEmpty) {
      // Ensure location is not empty
      String eventId = Uuid().v4();
      Map<String, dynamic> eventData = {
        "eventId": eventId,
        "name": nameController.text,
        "price": priceController.text,
        "category": _selectedCategory,
        "detail": detailController.text,
        "location": locationController.text, // Add location to Firestore
        "date": DateFormat("yyyy-MM-dd").format(selectedDate!),
        "time": selectedTime!.format(context),
        "timestamp": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("events")
          .doc(eventId)
          .set(eventData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Event Uploaded Successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form after upload
      nameController.clear();
      priceController.clear();
      detailController.clear();
      locationController.clear(); // Clear location field
      setState(() {
        _selectedCategory = null;
        selectedDate = null;
        selectedTime = null;
        _selectedImage = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Upload Event",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              GestureDetector(
                onTap: pickImage,
                child: Center(
                  child:
                      _selectedImage == null
                          ? Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                              size: 40,
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 25),

              // Event Name
              _buildLabel("Event Name"),
              _buildTextField(nameController, "Enter event name"),

              // Ticket Price
              SizedBox(height: 15),
              _buildLabel("Ticket Price"),
              _buildTextField(
                priceController,
                "Enter Price",
                keyboardType: TextInputType.number,
              ),

              // Category Dropdown
              SizedBox(height: 15),
              _buildLabel("Select Category"),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: _inputDecoration(),
              ),

              // Location Field
              SizedBox(height: 15),
              _buildLabel("Event Location"),
              _buildTextField(locationController, "Enter event location"),

              // Date & Time Picker
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectDate(context),
                      child: _buildDateTimeField(
                        selectedDate == null
                            ? "Select date"
                            : DateFormat("yyyy-MM-dd").format(selectedDate!),
                        Icons.calendar_today,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectTime(context),
                      child: _buildDateTimeField(
                        selectedTime == null
                            ? "Select time"
                            : selectedTime!.format(context),
                        Icons.access_time,
                      ),
                    ),
                  ),
                ],
              ),

              // Event Detail
              SizedBox(height: 15),
              _buildLabel("Event Detail"),
              _buildTextField(
                detailController,
                "What will be on that event...",
                maxLines: 3,
              ),

              // Upload Button
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: uploadEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Upload",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _buildDateTimeField(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
