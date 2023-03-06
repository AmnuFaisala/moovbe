import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
void main() {
  runApp(const Moovbe());
}

class Moovbe extends StatelessWidget {
  const Moovbe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ipadress',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const IpPage(title: 'IPadress'),
    );
  }
}

class IpPage extends StatefulWidget {
  const IpPage({super.key, required this.title});


  final String title;

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  TextEditingController IPController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: IPController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'IP.....',
                ),
              ),
            ),
            ElevatedButton(onPressed:submit,
                child: Text('Submit')),
          ],
        ),
      ),
    );
  }
  Future<void> submit()async{
    final pref = await SharedPreferences.getInstance();
    await pref.setString('IP', IPController.text);
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder:(_)=>HomePage(title: '',) ));
    });
  }
}
