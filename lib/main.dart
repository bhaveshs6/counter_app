// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter',
      theme: CupertinoThemeData(
        primaryColor: CupertinoDynamicColor.withBrightness(
          color: Color(0xFF007AFF),
          darkColor: Color(0xFF0A84FF),
        ),
        scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Colors.white,
          darkColor: Colors.black,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs; // The shared preferences instance
  int _counter = 0; // The current count

  bool _sessionStarted = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    _saveCounter();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _startSession() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionStarted = true;
    });
  }

  void _closeSession() async {
    await _prefs.clear();
    setState(() {
      _sessionStarted = false;
      _counter = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _prefs.getInt('counter') ?? 0;
      _sessionStarted = _prefs.getBool('sessionStarted') ?? false;
    });
  }

  void _saveCounter() {
    _prefs.setInt('counter', _counter);
    _prefs.setBool('sessionStarted', _sessionStarted);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Counter'),
      ),
      child: SafeArea(
        child: _sessionStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Progress:',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '$_counter',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: _incrementCounter,
                        child: const Icon(CupertinoIcons.add),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CupertinoButton(
                        onPressed: _resetCounter,
                        child: const Icon(CupertinoIcons.refresh),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('End Session?'),
                                content: const Text(
                                    'Are you sure you want to end the session? This will erase the progress.'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      _closeSession();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        color: CupertinoColors.destructiveRed,
                        child: const Text('End Session'),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CupertinoButton(
                  onPressed: _startSession,
                  child: const Text('Start Session'),
                ),
              ),
      ),
    );
  }
}
