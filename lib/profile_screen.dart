import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.blueAccent),
            title: Text('Take a Photo', style: TextStyle(color: Colors.white)),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.image, color: Colors.blueAccent),
            title: Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen after logout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101820),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeInDown(
          duration: Duration(milliseconds: 700),
          child: Text(
            'Profile',
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: BounceInDown(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt, size: 50, color: Color.fromRGBO(0, 0, 0, 0.7))
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
