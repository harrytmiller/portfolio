import 'package:flutter/material.dart';
import 'package:portfolio/pages/intro.dart';
import 'package:portfolio/pages/postuni.dart';
import 'package:portfolio/pages/year2.dart';
import 'package:portfolio/pages/year3.dart';
import 'package:portfolio/pages/writeup.dart';
import 'package:portfolio/pages/year2/DesignAnimate.dart'; // Design page
import 'package:portfolio/pages/year3/Dissertation.dart'; // Add your dissertation page import
import 'package:portfolio/pages/year2/Setap.dart'; // Add Setup page import
import 'package:portfolio/pages/year2/App.dart'; // Add App page import
import 'package:portfolio/pages/year3/ai.dart'; // Add App page import


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      initialRoute: '/Intro', 

      routes: {
        '/': (context) => Intro(), 
        '/Intro': (context) => Intro(), // Added explicit intro route
        '/Y2': (context) => Y2(),
        '/Y3': (context) => Y3(), 
        '/PostUni': (context) => PostUni(),
        '/WriteUps': (context) => WriteUps(),
        '/Design': (context) => Design(), 
        '/Dissertation': (context) => Dissertation(), // Add dissertation route
        '/Setup': (context) => Setup(), // Add Setup route
        '/App': (context) => App(), // Add App route
        '/Ai': (context) => AI(), // Add App route
      },
    );
  }
}