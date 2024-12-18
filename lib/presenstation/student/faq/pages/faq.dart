import 'package:flutter/material.dart';
import 'package:Sitama/core/config/themes/app_color.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.darkPrimaryDark : AppColors.lightPrimary,
        elevation: 0,
        title: Text(
          'FAQ - Mahasiswa',
          style: TextStyle(
            color: AppColors.lightWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildFAQSection(
              context,
              'Apa saja jenis notifikasi yang tersedia?',
              [
                'Notifikasi dari dosen mencakup: bimbingan direvisi, bimbingan disetujui, dan komentar logbook.',
                'Notifikasi akan otomatis ditandai sebagai sudah dibaca.',
                'Anda dapat melihat detail notifikasi melalui dropdown di pojok kanan atas halaman.',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Bagaimana cara mengelola bimbingan?',
              [
                'Halaman bimbingan menampilkan daftar bimbingan dengan empat status: belum diaksi, disetujui, direvisi, dan revisi yang telah diupdate.',
                'Untuk mengunggah bimbingan baru, gunakan fitur upload PDF pada halaman bimbingan.',
                'Setelah dosen memberikan komentar, Anda dapat melihat detail revisi yang diperlukan.',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Berapa file yang dapat saya unggah dalam satu kali pengiriman?',
              [
                'Dalam satu kali pengiriman, Anda hanya dapat mengunggah satu file PDF.',
                'Jika Anda perlu mengirim beberapa dokumen, lakukan pengiriman secara terpisah.',
                'Pastikan file yang diunggah sesuai dengan persyaratan yang ditentukan.',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Apa saja status bimbingan yang tersedia?',
              [
                'Terdapat empat status bimbingan:',
                '1. Belum diaksi: Bimbingan baru yang belum ditinjau dosen.',
                '2. Disetujui: Bimbingan telah disetujui tanpa perlu revisi.',
                '3. Direvisi: Dosen meminta Anda melakukan perubahan.',
                '4. Revisi yang telah diupdate: Anda telah mengunggah ulang dokumen setelah revisi.',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Cara menggunakan fitur logbook?',
              [
                'Di halaman logbook, Anda dapat menambahkan entri logbook baru.',
                'Setelah mengirim logbook, Anda dapat melihat komentar yang diberikan dosen.',
                'Anda memiliki opsi untuk mengedit atau menghapus entri logbook yang sudah dikirim.',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Pengaturan dan preferensi pengguna',
              [
                'Halaman setting menyediakan beberapa fitur pengaturan utama:',
                'Ubah profil pribadi dengan informasi terbaru.',
                'Ganti password akun untuk keamanan.',
                'Atur preferensi notifikasi sesuai kebutuhan.',
                'Pilih tema aplikasi: mode terang atau gelap (dark theme).',
              ],
              isDarkMode,
            ),
            _buildFAQSection(
              context,
              'Apa yang harus dilakukan jika mengalami kendala teknis?',
              [
                'Pastikan koneksi internet stabil.',
                'Coba refresh halaman atau logout dan login kembali.',
                'Jika masalah berlanjut, catat detail kendala yang dialami.',
                'Hubungi admin atau tim support dengan menyertakan tangkapan layar (screenshot) jika diperlukan.',
              ],
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, String question, List<String> answers, bool isDarkMode) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: isDarkMode ? AppColors.darkWhite.withOpacity(0.1) : AppColors.lightWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDarkMode 
              ? AppColors.darkGray.withOpacity(0.2) 
              : AppColors.lightGray.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          collapsedIconColor: isDarkMode ? AppColors.lightWhite : AppColors.lightBlack,
          iconColor: isDarkMode ? AppColors.lightWhite : AppColors.lightBlack,
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.lightWhite : AppColors.lightBlack,
              fontSize: 16,
            ),
          ),
          children: answers.map((answer) => ListTile(
            title: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode 
                    ? AppColors.lightWhite.withOpacity(0.9) 
                    : AppColors.lightBlack.withOpacity(0.9),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
          )).toList(),
        ),
      ),
    );
  }
}