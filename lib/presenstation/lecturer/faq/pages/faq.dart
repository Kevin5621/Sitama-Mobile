import 'package:flutter/material.dart';

class LecturerFAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ - Dosen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildFAQSection(
            'Bagaimana cara melihat progres mahasiswa?',
            [
              '1. Masuk ke akun Anda sebagai Dosen.',
              '2. Pada menu utama, pilih opsi Mahasiswa.',
              '3. Pilih nama mahasiswa yang ingin Anda lihat progresnya.',
              '4. Anda akan melihat daftar logbook, status bimbingan, dan nilai yang telah diberikan.',
            ],
          ),
          _buildFAQSection(
            'Bagaimana cara memanage bimbingan mahasiswa?',
            [
              '1. Masuk ke akun Anda sebagai Dosen.',
              '2. Pada menu utama, pilih opsi Bimbingan.',
              '3. Anda akan melihat daftar permintaan bimbingan dari mahasiswa.',
              '4. Klik pada permintaan untuk melihat detailnya.',
              '5. Anda dapat menyetujui, menolak, atau menjadwalkan ulang bimbingan sesuai kebutuhan.',
            ],
          ),
          _buildFAQSection(
            'Bagaimana cara memberi nilai mahasiswa?',
            [
              '1. Masuk ke akun Anda sebagai Dosen.',
              '2. Pada menu utama, pilih opsi Penilaian.',
              '3. Pilih nama mahasiswa yang ingin Anda beri nilai.',
              '4. Isi form penilaian sesuai dengan kriteria yang tersedia.',
              '5. Tekan tombol Simpan untuk menyimpan nilai mahasiswa.',
            ],
          ),
          _buildFAQSection(
            'Bagaimana cara melihat logbook mahasiswa?',
            [
              '1. Masuk ke akun Anda sebagai Dosen.',
              '2. Pada menu utama, pilih opsi Logbook.',
              '3. Pilih nama mahasiswa untuk melihat logbook-nya.',
              '4. Anda dapat memberikan komentar atau masukan pada logbook tersebut jika diperlukan.',
            ],
          ),
          _buildFAQSection(
            'Bagaimana jika saya menemukan kendala saat menggunakan aplikasi?',
            [
              '1. Hubungi admin melalui fitur Bantuan di aplikasi.',
              '2. Kirim email ke: support@aplikasimagang.com.',
              '3. Jelaskan masalah yang Anda hadapi dengan detail.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(String question, List<String> answers) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: answers
          .map(
            (answer) => ListTile(
              title: Text(
                answer,
                style: TextStyle(fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }
}
