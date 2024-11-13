import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class LoadNotification extends StatefulWidget {
  final VoidCallback onClose;

  const LoadNotification({Key? key, required this.onClose}) : super(key: key);

  @override
  _LoadNotificationState createState() => _LoadNotificationState();
}

class _LoadNotificationState extends State<LoadNotification> {
  late List<Color> _colors;
  late int _colorIndex;

  @override
  void initState() {
    super.initState();
    _colorIndex = 0;
    _colors = [
      AppColors.lightWarning,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.deepPurpleAccent,
      AppColors.lightPrimary,
      Colors.purpleAccent,
    ];
    _startGradientAnimation();
  }

  void _startGradientAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colors.length;
      });
      _startGradientAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              _colors[_colorIndex],
              _colors[(_colorIndex + 1) % _colors.length],
            ],
            end: Alignment.bottomRight,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.campaign,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: const Text(
              "Informasi Baru!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "21/11/2024",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.event_note_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Anda telah dijadwalkan bimbingan 3 yang dilaksanakan pada Kamis, 17 Oktober 2024.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
