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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final channelName = 'com.oleg.lysenko/documentPicker';
  final methodChannel = MethodChannel(channelName);
  List<dynamic> _imagesDataList = [];

  void _openDocumentPicker() async {
    try {
      dynamic response = await methodChannel.invokeMethod('start');
      if (response != null) {
        setState(() {
          _imagesDataList = response;
        });
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: _imagesDataList.length,
          itemBuilder: (ctx, index) {
            final source = base64Decode(_imagesDataList[index]);
            return source != null ? Image.memory(source) : Placeholder();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDocumentPicker,
        child: Icon(Icons.photo),
      ),
    );
  }
}
