import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Login/login.dart';

import 'package:ticket_management_system/Service%20Provider/service_home.dart';
import 'package:ticket_management_system/provider/notification_provider.dart';
import 'package:ticket_management_system/provider/pieChart_provider.dart';
import 'package:ticket_management_system/screens/splash.dart';
import 'package:ticket_management_system/screens/split_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB_fOQYy-vxioJGKb7xJddHAOSNAxojE-M",
        authDomain: "tmsupdated.firebaseapp.com",
        projectId: "tmsupdated",
        storageBucket: "tmsupdated.appspot.com",
        messagingSenderId: "540592045536",
        appId: "1:540592045536:android:d33bbc3ef1585399c43f85",
        measurementId: "G-Y8QZ3ETK3Z"),
  );

  await FlutterDownloader.initialize(
      debug: true // Set this to false in production
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PiechartProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TMS APP',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home:
            //Report2(),
            // Report1(),
            // Imagepick(),
            //PieChartWidget(),
            //     pendingstatus(
            //   Number: '#1077',
            // ),
            // pending(),
            //     Raise(
            //   userID: '',
            // ),
            //report1(),
            //     pendingstatus(
            //   Number: '',
            //   key: Key(''),
            // )
            //HomeScreen(userID: 'AX3265'),
            //     spliScreen(
            //   userID: 'RT0969',
            // )
            // const FilteredReport(),
            // dash(),
            //     Homeservice(
            //   userID: '',
            // ),
            //     ReportTicketScreen(
            //   asset: '',
            //   work: '',
            //   building: '',
            //   floor: '',
            //   remark: '',
            //   room: '',
            //   ticketNo: '',
            // ),
            // pendingstatus_service(
            //   Number: '68',
            // ),
            //service_pending(),
            // LoginService()
            //serviceSignup()
            //const LoginPage(),
            // SignupPage(),
            SpalashScreen(),
      ),
    );
  }
}
