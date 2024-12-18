import 'package:flutter/material.dart';

import 'package:Sitama/core/config/themes/app_color.dart';

class LecturerFAQPage extends StatelessWidget {
  const LecturerFAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.darkPrimaryDark : AppColors.lightPrimary,
        elevation: 0,
        title: Text(
          'FAQ - Dosen',
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
                'Bagaimana cara melihat daftar mahasiswa bimbingan?',
                [
                  'Setelah login, Anda akan langsung melihat daftar mahasiswa bimbingan yang telah ditugaskan oleh admin.',
                  'Gunakan filter jurusan dan tahun ajaran di bagian atas untuk mempermudah pencarian mahasiswa.',
                  'Anda dapat mengelompokkan mahasiswa menggunakan fitur group atau mengarsipkan mahasiswa yang sudah selesai dengan fitur archive.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara menggunakan fitur filter dan pengelompokan?',
                [
                  'Filter Jurusan: Pilih jurusan spesifik dari dropdown menu untuk melihat mahasiswa dari jurusan tersebut.',
                  'Filter Tahun Ajaran: Pilih tahun ajaran untuk melihat mahasiswa dari periode tersebut.',
                  'Pengelompokan: Gunakan fitur group untuk mengelompokkan mahasiswa berdasarkan kriteria tertentu seperti project atau tema penelitian.',
                  'Archive: Mahasiswa yang telah selesai bimbingan dapat diarsipkan untuk menjaga daftar tetap terorganisir.',
                ],
                isDarkMode,               
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara mengelola status bimbingan mahasiswa?',
                [
                  'Buka detail mahasiswa dengan mengklik nama mahasiswa dari daftar.',
                  'Pada halaman detail, Anda dapat melihat data lengkap mahasiswa dan status bimbingannya.',
                  'Jika mahasiswa telah menyelesaikan bimbingan, klik tombol "Selesai Bimbingan" untuk membuka halaman penilaian.',
                  'Setelah mengklik tombol tersebut, form penilaian akan muncul dan Anda dapat memberikan nilai sesuai kriteria.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara mengelola bimbingan yang dikirim mahasiswa?',
                [
                  'Pada detail mahasiswa, Anda dapat melihat file bimbingan yang dikirimkan.',
                  'Anda dapat memberi komentar pada setiap file bimbingan.',
                  'Setelah mereview, Anda memiliki opsi untuk memberi approval atau meminta revisi.',
                  'Jika meminta revisi, mahasiswa akan mendapat notifikasi untuk mengupload file revisi.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara melihat dan memberi komentar pada logbook?',
                [
                  'Akses logbook melalui tab Logbook pada detail mahasiswa.',
                  'Anda dapat melihat semua aktivitas mahasiswa yang tercatat dalam logbook.',
                  'Berikan komentar atau feedback pada setiap entry logbook jika diperlukan.',
                  'Berbeda dengan bimbingan, pada logbook Anda hanya dapat memberi komentar tanpa perlu menerima file.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Apa perbedaan antara bimbingan dan logbook?',
                [
                  'Bimbingan: Merupakan file atau dokumen formal yang memerlukan approval atau revisi dari dosen.',
                  'Logbook: Merupakan catatan aktivitas harian/mingguan mahasiswa yang hanya memerlukan komentar dari dosen.',
                  'Pada bimbingan, Anda dapat menerima file dan memberikan status (approval/revisi).',
                  'Pada logbook, Anda hanya dapat memberikan komentar tanpa perlu menerima file.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara memberikan penilaian akhir?',
                [
                  'Pastikan mahasiswa telah menyelesaikan semua tahap bimbingan yang diperlukan.',
                  'Klik tombol "Selesai Bimbingan" pada halaman detail mahasiswa.',
                  'Form penilaian akan muncul setelah Anda mengkonfirmasi penyelesaian bimbingan.',
                  'Isi semua kriteria penilaian yang tersedia.',
                  'Setelah nilai disubmit, status mahasiswa akan otomatis diperbarui.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana jika saya perlu mengubah nilai yang sudah disubmit?',
                [
                  'Hubungi admin untuk mengajukan perubahan nilai.',
                  'Perubahan nilai hanya dapat dilakukan dengan persetujuan admin.',
                  'Pastikan Anda memiliki alasan yang valid untuk perubahan nilai.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Mengapa saya tidak bisa melihat beberapa mahasiswa?',
                [
                  'Pastikan filter jurusan dan tahun ajaran sudah sesuai.',
                  'Cek apakah mahasiswa tersebut mungkin berada dalam arsip.',
                  'Periksa apakah Anda sudah mengelompokkan mahasiswa dalam group tertentu.',
                  'Jika masih bermasalah, hubungi admin untuk memastikan mahasiswa telah ditugaskan ke Anda.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Bagaimana cara menggunakan fitur archive yang efektif?',
                [
                  'Arsipkan mahasiswa setelah semua proses bimbingan dan penilaian selesai.',
                  'Mahasiswa yang diarsipkan akan dipindahkan ke tab Archive.',
                  'Anda masih dapat melihat history bimbingan dan logbook mahasiswa yang diarsipkan.',
                  'Jika diperlukan, mahasiswa dapat dikembalikan dari arsip ke daftar aktif melalui admin.',
                ],
                isDarkMode,
              ),
              _buildFAQSection(
                context,
                'Apa yang harus dilakukan jika ada kendala teknis?',
                [
                  'Pastikan koneksi internet Anda stabil.',
                  'Coba refresh halaman atau logout dan login kembali.',
                  'Jika masalah masih berlanjut, catat detail masalah yang Anda hadapi.',
                  'Hubungi admin atau tim support dengan menyertakan screenshot jika diperlukan.',
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