import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotificationPracticeApp());
}

class NotificationService {
  static const String channelId = 'lab10_demo_channel';
  static const String channelName = 'Lab 10 Demo Notifications';
  static const String channelDescription =
      'Practice notifications for important user actions';

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await plugin.initialize(settings: settings);

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
      ),
    );
  }

  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    return await androidPlugin?.requestNotificationsPermission() ?? true;
  }

  Future<bool> areNotificationsEnabled() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    return await androidPlugin?.areNotificationsEnabled() ?? false;
  }

  Future<void> showDemoNotification({
    required String title,
    required String body,
  }) async {
    await plugin.show(
      id: 1,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_launcher',
        ),
      ),
    );
  }
}

class NotificationPracticeApp extends StatelessWidget {
  const NotificationPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.5 Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const NotificationDemoScreen(),
    );
  }
}

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final NotificationService notificationService = NotificationService();

  bool notificationsEnabled = false;
  String statusMessage = 'Preparing notifications...';

  @override
  void initState() {
    super.initState();
    setupNotifications();
  }

  Future<void> setupNotifications() async {
    await notificationService.initialize();
    final bool granted = await notificationService.requestPermission();
    final bool enabled = await notificationService.areNotificationsEnabled();

    if (!mounted) {
      return;
    }

    setState(() {
      notificationsEnabled = enabled;
      statusMessage = granted
          ? 'Permission granted. Tap the button to trigger a demo notification.'
          : 'Permission was not granted yet.';
    });
  }

  Future<void> requestPermission() async {
    final bool granted = await notificationService.requestPermission();
    final bool enabled = await notificationService.areNotificationsEnabled();

    if (!mounted) {
      return;
    }

    setState(() {
      notificationsEnabled = enabled;
      statusMessage = granted
          ? 'Notifications are ready.'
          : 'Permission is still denied.';
    });
  }

  Future<void> showNotification() async {
    await notificationService.showDemoNotification(
      title: 'Login success',
      body: 'This is the local notification demo for Lab 10.5.',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      statusMessage = 'Notification was requested from the Android system.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notification Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Notifications enabled: $notificationsEnabled'),
                  const SizedBox(height: 8),
                  Text(statusMessage),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: requestPermission,
              child: const Text('Request permission'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: notificationsEnabled ? showNotification : null,
              child: const Text('Show demo notification'),
            ),
          ),
        ],
      ),
    );
  }
}
