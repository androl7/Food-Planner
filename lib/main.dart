import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_planner/screens/home_screen_list.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(181,239,247,0.9), Colors.white])),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Planner',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: HomeScreenList()
      ),
    );
  }
}
