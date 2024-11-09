import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/service/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final UserRole userRole;

  const NotificationSettingsScreen({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // General Settings
  bool _generalNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showPreview = true;

  // Mahasiswa Settings
  bool _announcementNotifications = true;
  bool _guidanceApprovalNotifications = true;
  bool _guidanceRejectionNotifications = true;
  bool _logbookCommentNotifications = true;

  // Dosen Settings
  bool _newGuidanceNotifications = true;
  bool _revisedGuidanceNotifications = true;
  bool _newLogbookNotifications = true;
  bool _studentProgressAlerts = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadNotificationSettings();
  }

  Future<void> _initializeNotifications() async {
    // Initialize Flutter Local Notifications
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (response.payload != null) {
          // Navigate based on payload
        }
      },
    );

    // Request permissions for iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _generalNotifications = prefs.getBool('generalNotifications') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
      _showPreview = prefs.getBool('showPreview') ?? true;

      if (widget.userRole == UserRole.mahasiswa) {
        _announcementNotifications = prefs.getBool('announcementNotifications') ?? true;
        _guidanceApprovalNotifications = prefs.getBool('guidanceApprovalNotifications') ?? true;
        _guidanceRejectionNotifications = prefs.getBool('guidanceRejectionNotifications') ?? true;
        _logbookCommentNotifications = prefs.getBool('logbookCommentNotifications') ?? true;
      } else {
        _newGuidanceNotifications = prefs.getBool('newGuidanceNotifications') ?? true;
        _revisedGuidanceNotifications = prefs.getBool('revisedGuidanceNotifications') ?? true;
        _newLogbookNotifications = prefs.getBool('newLogbookNotifications') ?? true;
        _studentProgressAlerts = prefs.getBool('studentProgressAlerts') ?? true;
      }
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save general settings
    await prefs.setBool('generalNotifications', _generalNotifications);
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
    await prefs.setBool('showPreview', _showPreview);

    // Save role-specific settings
    if (widget.userRole == UserRole.mahasiswa) {
      await prefs.setBool('announcementNotifications', _announcementNotifications);
      await prefs.setBool('guidanceApprovalNotifications', _guidanceApprovalNotifications);
      await prefs.setBool('guidanceRejectionNotifications', _guidanceRejectionNotifications);
      await prefs.setBool('logbookCommentNotifications', _logbookCommentNotifications);
    } else {
      await prefs.setBool('newGuidanceNotifications', _newGuidanceNotifications);
      await prefs.setBool('revisedGuidanceNotifications', _revisedGuidanceNotifications);
      await prefs.setBool('newLogbookNotifications', _newLogbookNotifications);
      await prefs.setBool('studentProgressAlerts', _studentProgressAlerts);
    }

    // Update notification channel settings
    await _updateNotificationChannels();
  }

  Future<void> _updateNotificationChannels() async {
    if (!_generalNotifications) {
      await _flutterLocalNotificationsPlugin.cancelAll();
      return;
    }

    // Create or update the default channel with current settings
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Default notification channel',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
      ),
      body: ListView(
        children: [
          _buildGeneralSection(),
          const Divider(),
          widget.userRole == UserRole.dosen 
              ? _buildDosenSection() 
              : _buildMahasiswaSection(),
          const Divider(),
          _buildNotificationPreferences(),
        ],
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Umum',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SwitchListTile(
          title: const Text('Semua Notifikasi'),
          subtitle: const Text('Aktifkan atau nonaktifkan semua notifikasi'),
          value: _generalNotifications,
          onChanged: (bool value) {
            setState(() {
              _generalNotifications = value;
              // If turning off all notifications, disable all specific notifications
              if (!value) {
                _announcementNotifications = false;
                _guidanceApprovalNotifications = false;
                _guidanceRejectionNotifications = false;
                _logbookCommentNotifications = false;
                _newGuidanceNotifications = false;
                _revisedGuidanceNotifications = false;
                _newLogbookNotifications = false;
                _studentProgressAlerts = false;
              }
            });
            _saveNotificationSettings();
          },
        ),
      ],
    );
  }

  Widget _buildMahasiswaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Notifikasi Mahasiswa',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (_generalNotifications) ...[
          SwitchListTile(
            title: const Text('Pengumuman'),
            subtitle: const Text('Notifikasi pengumuman dari dosen dan fakultas'),
            value: _announcementNotifications,
            onChanged: (bool value) {
              setState(() {
                _announcementNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Bimbingan Disetujui'),
            subtitle: const Text('Notifikasi saat bimbingan disetujui oleh dosen'),
            value: _guidanceApprovalNotifications,
            onChanged: (bool value) {
              setState(() {
                _guidanceApprovalNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Bimbingan Ditolak'),
            subtitle: const Text('Notifikasi saat bimbingan ditolak oleh dosen'),
            value: _guidanceRejectionNotifications,
            onChanged: (bool value) {
              setState(() {
                _guidanceRejectionNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Komentar Logbook'),
            subtitle: const Text('Notifikasi saat dosen memberikan komentar pada logbook'),
            value: _logbookCommentNotifications,
            onChanged: (bool value) {
              setState(() {
                _logbookCommentNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildDosenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Notifikasi Dosen',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (_generalNotifications) ...[
          SwitchListTile(
            title: const Text('Bimbingan Baru'),
            subtitle: const Text('Notifikasi saat mahasiswa mengajukan bimbingan baru'),
            value: _newGuidanceNotifications,
            onChanged: (bool value) {
              setState(() {
                _newGuidanceNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Revisi Bimbingan'),
            subtitle: const Text('Notifikasi saat mahasiswa mengirim revisi bimbingan'),
            value: _revisedGuidanceNotifications,
            onChanged: (bool value) {
              setState(() {
                _revisedGuidanceNotifications = value;
                });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Logbook Baru'),
            subtitle: const Text('Notifikasi saat mahasiswa mengirim logbook baru'),
            value: _newLogbookNotifications,
            onChanged: (bool value) {
              setState(() {
                _newLogbookNotifications = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Alert Progress Mahasiswa'),
            subtitle: const Text('Notifikasi saat ada mahasiswa yang progressnya terhambat'),
            value: _studentProgressAlerts,
            onChanged: (bool value) {
              setState(() {
                _studentProgressAlerts = value;
              });
              _saveNotificationSettings();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Preferensi Notifikasi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (_generalNotifications) ...[
          SwitchListTile(
            title: const Text('Suara'),
            subtitle: const Text('Aktifkan suara notifikasi'),
            value: _soundEnabled,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Getar'),
            subtitle: const Text('Aktifkan getaran saat ada notifikasi'),
            value: _vibrationEnabled,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
              });
              _saveNotificationSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Tampilkan Preview'),
            subtitle: const Text('Tampilkan detail notifikasi di layar kunci'),
            value: _showPreview,
            onChanged: (bool value) {
              setState(() {
                _showPreview = value;
              });
              _saveNotificationSettings();
            },
          ),
        ],
      ],
    );
  }
}