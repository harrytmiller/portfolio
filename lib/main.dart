import 'package:flutter/material.dart';
import 'package:portfolio/pages/intro.dart';
import 'package:portfolio/pages/postuni.dart';
import 'package:portfolio/pages/year2.dart';
import 'package:portfolio/pages/year3.dart';
import 'package:portfolio/pages/writeup.dart';
import 'package:portfolio/pages/year2/DesignAnimate.dart';
import 'package:portfolio/pages/year3/Dissertation.dart';
import 'package:portfolio/pages/year2/setap.dart';
import 'package:portfolio/pages/year3/ai.dart';
import 'package:portfolio/pages/postUni/ai_image_gen.dart';
import 'package:portfolio/pages/postUni/ai_model_gen.dart';
import 'package:portfolio/pages/postUni/chess.dart';
import 'package:portfolio/pages/postUni/planner.dart';
import 'package:portfolio/pages/postUni/job.dart';
import 'package:portfolio/pages/postUni/api.dart';

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
      initialRoute: '/',
      
      routes: {
        '/': (context) => Intro(),
        '/Intro': (context) => Intro(),
        '/Y2': (context) => Y2(),
        '/Y3': (context) => Y3(),
        '/PostUni': (context) => PostUni(),
        '/WriteUps': (context) => WriteUps(),
        '/Design': (context) => Design(),
        '/Dissertation': (context) => Dissertation(),
        '/Setup': (context) => Setup(),
        '/Ai': (context) => AI(),
        '/AiImageGen': (context) => AiImageGen(),
        '/AiModelGen': (context) => ModelPage(),
        '/Chess': (context) => Chess(),
        '/Project1': (context) => Project1(),
        '/Project2': (context) => Project2(),
        '/Project3': (context) => Project3(),
      },
    );
  }
}