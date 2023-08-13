import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiko/data/repo/arvhive_repo.dart';
import 'package:tiko/features/archive/bloc/archive_bloc.dart';
import 'package:tiko/firebase_options.dart';
import 'package:tiko/locator.dart';
import 'package:tiko/root.dart';

Future<void> _firebaseMesgBackgroundHandler(RemoteMessage remoteMsg) async {
  await Firebase.initializeApp();
  print('Handling background mes:${remoteMsg.messageId}');
}

//for forground notif step 1 for firebase
const AndroidNotificationChannel firbseChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  description:
      'This channel is used for important notifications.', //description
  importance: Importance.max,
);

//for forground notif step 1 for downlaod

const AndroidNotificationChannel downloadChannel = AndroidNotificationChannel(
  'download_channel', // id
  'Download Notifications', // title

  description:
      'This channel is used for downloading notifications.', //description
  importance: Importance.max,
);
//create local notif plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();

  setup();

  await MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.getToken();

  //handle backgroud message
  FirebaseMessaging.onBackgroundMessage(_firebaseMesgBackgroundHandler);

//handel forground msg

  if (Platform.isAndroid) {
    //for forground notif step 2

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher')));
    //for forground notif step 3

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(firbseChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(downloadChannel);
    //fot forground msg step4
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              firbseChannel.id,
              firbseChannel.name,
              channelDescription: firbseChannel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ));

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        return;
      }
    });
  }

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => ArchiveBloc(locator<IArchiveRepository>()))
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            bodyMedium: GoogleFonts.roboto(),
            titleMedium: GoogleFonts.roboto(),
            titleSmall: GoogleFonts.roboto(),
            titleLarge: GoogleFonts.roboto(),
            displayLarge: GoogleFonts.roboto(),
            bodyLarge: GoogleFonts.roboto()),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RoootScreen(),
    );
  }
}
