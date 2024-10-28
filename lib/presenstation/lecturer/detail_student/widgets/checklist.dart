import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/tandai_selesai.dart';

class CheckButton extends StatefulWidget {
  final bool isChecked; // Status apakah tombol sudah dicek
  final bool isStarRounded; // Status apakah bintang tumpul
  final VoidCallback onToggle; // Callback untuk menangani klik checklist
  final VoidCallback onStarToggle; // Callback untuk menangani klik bintang

  // Mendefinisikan IconData untuk ikon bintang
  static const IconData starRounded =
      IconData(0xf01d4, fontFamily: 'MaterialIcons');

  const CheckButton({
    Key? key,
    required this.isChecked,
    required this.isStarRounded,
    required this.onToggle,
    required this.onStarToggle,
  }) : super(key: key);

  @override
  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  bool isStarActive = false; // Status apakah bintang aktif

  void _toggleStar() {
    setState(() {
      isStarActive = !isStarActive; // Toggle status bintang
      widget.onStarToggle(); // Panggil callback jika perlu
    });
  }

  void _showTandaiSelesaiDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TandaiSelesaiDialog(
          onConfirm: () {
            // Panggil fungsi onToggle saat tombol Lanjut diklik
            widget.onToggle();
            print("Tindakan Lanjut dipilih");
          },
          onCancel: () {
            print("Tindakan Batal dipilih");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ukuran baris mengikuti konten
      children: [
        GestureDetector(
          onTap: () {
            _showTandaiSelesaiDialog(); // Tampilkan dialog setelah checklist diklik
          },
          child: Container(
            width: 40, // Ukuran lebar button
            height: 40, // Ukuran tinggi button
            decoration: BoxDecoration(
              color: widget.isChecked
                  ? Colors.green
                  : Colors.transparent, // Latar belakang hijau jika checked
              borderRadius: BorderRadius.circular(10), // Radius sudut
              border:
                  Border.all(color: Colors.grey), // Tambahkan border jika perlu
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.isChecked
                  ? Icons.check
                  : null, // Tampilkan ikon check jika checked
              color: widget.isChecked
                  ? Colors.white
                  : Colors.transparent, // Ikon putih jika checked
              size: 20, // Ukuran ikon checklist
            ),
          ),
        ),
        const SizedBox(width: 8), // Jarak antara tombol check dan star
        GestureDetector(
          onTap: _toggleStar, // Panggil fungsi _toggleStar saat diklik
          child: Container(
            width: 40, // Ukuran lebar button bintang
            height: 40, // Ukuran tinggi button bintang
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20), // Radius sudut untuk bintang
              color: Colors.transparent, // Warna latar belakang transparan
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Garis tepi bintang abu-abu
                Icon(
                  CheckButton.starRounded,
                  color: Colors.grey, // Warna garis tepi diubah menjadi abu-abu
                  size: 30, // Ukuran ikon bintang yang lebih besar
                ),
                // Ikon bintang
                Icon(
                  CheckButton.starRounded, // Menggunakan starRounded
                  color: isStarActive
                      ? Colors.orangeAccent
                      : Colors.transparent, // Warna ikon bintang
                  size: 30, // Ukuran ikon bintang yang lebih besar
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
