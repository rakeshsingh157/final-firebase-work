import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class SupportScreen extends StatelessWidget {
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
            'Support',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FadeInUp(
          duration: Duration(milliseconds: 800),
          child: Text(
            'How can we help you?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
