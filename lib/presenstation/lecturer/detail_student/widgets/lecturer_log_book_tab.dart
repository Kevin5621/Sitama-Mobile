import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';

/// Widget [LecturerLogBookTab] menampilkan daftar logbook mahasiswa dalam bentuk list.
/// Setiap logbook dapat diekspansi untuk melihat detail aktivitas serta memberikan komentar.
class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;

  /// Konstruktor menerima daftar logbook yang akan ditampilkan.
  const LecturerLogBookTab({super.key, required this.logBooks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8), 
          color: AppColors.white, 
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent), 
            child: ExpansionTile(
              title: Text(logBooks[index].title), 
              subtitle: Text('Date: ${logBooks[index].date}'), 
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(logBooks[index].activity),
                      const SizedBox(height: 16),
                      const Text(
                        'Komentar Dosen:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8), 

                      // TextField untuk menambahkan komentar dosen
                      const TextField(
                        maxLines: 3, // Jumlah maksimal baris dalam TextField
                        decoration: InputDecoration(
                          hintText: 'Tambahkan komentar di sini...',
                          border: OutlineInputBorder(), 
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Row untuk menempatkan tombol "Simpan Komentar" di kanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, 
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implementasi logika untuk menyimpan komentar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Komentar berhasil disimpan'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary, 
                            ),
                            child: const Text(
                              'Simpan Komentar',
                              style: TextStyle(
                                color: AppColors.white, 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
