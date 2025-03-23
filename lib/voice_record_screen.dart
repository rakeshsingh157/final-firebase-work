// flutter_app/lib/voice_record_screen.dart

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class VoiceRecordScreen extends StatelessWidget {
  void _pickAudio(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      File audioFile = File(file.path!);

      try {
        var request = http.MultipartRequest('POST', Uri.parse('https://server-beta-black-61.vercel.app/upload')); // Replace with your server IP

        request.files.add(await http.MultipartFile.fromPath(
          'file',
          audioFile.path,
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
            SnackBar(content: Text('Audio uploaded successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload audio.')),
          );
        }
      } catch (e) {
        print('Error uploading audio: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during upload.')),
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
            'Voice Recording',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: BounceInUp(
        duration: Duration(milliseconds: 800),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => _pickAudio(context),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Center(
        child: FadeIn(
          duration: Duration(milliseconds: 800),
          child: Text(
            'Record or Upload Audio',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}