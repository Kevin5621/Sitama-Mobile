import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ - Mahasiswa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildFAQSection(
            'Bagaimana cara menambah bimbingan di aplikasi?',
            [
              '1. Masuk ke akun Anda sebagai Mahasiswa.',
              '2. Pada menu utama, pilih opsi Bimbingan.',
              '3. Klik tombol Tambah Bimbingan.',
              '4. Isi formulir yang tersedia:',
              '   - Judul Bimbingan: Masukkan judul yang sesuai.',
              '   - Deskripsi: Jelaskan secara singkat topik atau isu yang ingin dibahas.',
              '   - Tanggal dan Waktu: Pilih jadwal bimbingan yang diinginkan.',
              '5. Tekan tombol Kirim.',
              '6. Tunggu persetujuan dari Dosen Pembimbing. Anda akan diberitahu melalui notifikasi aplikasi.',
            ],
          ),
          _buildFAQSection(
            'Apa itu logbook, dan bagaimana cara menambah logbook?',
            [
              'Logbook adalah catatan harian kegiatan magang.',
              '1. Masuk ke akun Anda sebagai Mahasiswa.',
              '2. Pada menu utama, pilih opsi Logbook.',
              '3. Klik tombol Tambah Logbook.',
              '4. Isi detail logbook seperti:',
              '   - Tanggal: Pilih tanggal kegiatan.',
              '   - Kegiatan: Tuliskan kegiatan yang Anda lakukan.',
              '   - Durasi Waktu: Cantumkan waktu yang dihabiskan.',
              '   - Hasil/Keterangan: Jelaskan hasil atau output dari kegiatan tersebut.',
              '5. Tekan tombol Simpan.',
              '6. Logbook Anda akan langsung tersimpan.',
            ],
          ),
          _buildFAQSection(
            'Bagaimana cara memastikan bimbingan atau logbook sudah berhasil ditambahkan?',
            [
              '- Bimbingan: Cek status di menu Riwayat Bimbingan. Status Menunggu Persetujuan berarti masih diproses.',
              '- Logbook: Semua logbook yang ditambahkan akan terlihat di daftar logbook.',
            ],
          ),
          _buildFAQSection(
            'Apakah ada batasan jumlah bimbingan atau logbook yang bisa ditambahkan?',
            [
              '- Tidak ada batasan untuk logbook.',
              '- Untuk bimbingan, jumlah maksimal ditentukan oleh kebijakan dosen pembimbing.',
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
