import 'package:flutter/material.dart';
import 'package:internet_radio_app/pages/home_page.dart';
import 'package:internet_radio_app/pages/radio_page.dart';
import 'package:internet_radio_app/services/player_state_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerStateProvider(),
          child: RadioPage(),
        )
      ],
      child: MaterialApp(
          title: 'Radio Station',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Montserrat'),
          home: SafeArea(
            bottom: false,
            child: Scaffold(primary: false, body: HomePage()),
          )),
    );
  }
}


