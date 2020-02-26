import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final channelName = 'com.oleg.lysenko/documentPicker';
  final methodChannel = MethodChannel(channelName);

  Image _image;

  void _openDocumentPicker() async {
    try {
      dynamic response = await methodChannel.invokeMethod('start');
      if (response != null && response is String) {
        final image = Image.memory(base64Decode(response));

        if (image != null) {
          setState(() {
            _image = image;
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_image != null) ? _image : Placeholder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDocumentPicker,
        child: Icon(Icons.photo),
      ),
    );
  }
}
