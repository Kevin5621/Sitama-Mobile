import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        backgroundColor: Color(0xFF3B5998), // Dekorasi biru muda pada AppBar
      ),
      backgroundColor: Colors.white, // Latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Aplikasi
            Center(
              child: Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.all(20.0),
                child: Image.asset(AppImages.logo ),
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: Text(
                'Sitama',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),

            SizedBox(height: 10),
            Center(
              child: Text(
                'Sitama adalah aplikasi buatan mahasiswa Politeknik Negeri Semarang, yang dirancang untuk memudahkan mahasiswa Politeknik Negeri Semarang dan mentor nya menjalani program magang.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Fitur Utama:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),

            // Daftar Fitur
            ListTile(
              leading: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text('Pencarian Program Magang'),
            ),
            ListTile(
              leading: Icon(Icons.track_changes, color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text('Pelacakan Progress Magang'),
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text('Penilaian dan Feedback'),
            ),
            ListTile(
              leading: Icon(Icons.people, color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text('Koneksi dengan Mentor'),
            ),

            SizedBox(height: 20),
            Text(
              'Versi Aplikasi: 1.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Dikembangkan oleh: Tim Sitama',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
