import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class VideoRecordScreen extends StatelessWidget {
  Future<void> _pickVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video); // Change to FileType.video

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      File videoFile = File(file.path!); // Change to videoFile

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://server-beta-black-61.vercel.app/upload'), // Replace with your server URL
        );

        request.files.add(await http.MultipartFile.fromPath(
          'file',
          videoFile.path,
        ));

        // Get the current user's UID
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          request.fields['uid'] = user.uid; // Add UID to the request
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not logged in.')),
          );
          return;
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video uploaded successfully!')), // Change to Video
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload video. Status code: ${response.statusCode}')), // Change to Video
          );
        }
      } catch (e) {
        print('Error uploading video: $e'); // Change to Video
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during upload: $e')),
        );
      }
    }
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
            'Video Recording', // Change to Video
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: BounceInUp(
        duration: Duration(milliseconds: 800),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => _pickVideo(context), // Change to _pickVideo
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Center(
        child: FadeIn(
          duration: Duration(milliseconds: 800),
          child: Text(
            'Record or Upload Video', // Change to Video
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}