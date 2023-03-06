import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'moovbe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: ''),
        // routes: {
        //   'login' : (ctx){
        //     return LoginPage(title: '',);
        //   },
        // },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

   final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.red,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: [
             Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(text: "moov",style: GoogleFonts.poppins(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold),
                         children:[
                           TextSpan(text: "be",style: GoogleFonts.poppins(color: Colors.yellowAccent,fontSize: 50,fontWeight: FontWeight.bold),)
                         ]
                     ),

                     ),
                 ],
               ),
             ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: InkWell(onTap: (){
                  // Navigator.of(context).pushNamed('login');
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginPage(title: '',)));
                },
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // alignment: Alignment.bottomCenter,

                      child: Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Text("Get Started",style: GoogleFonts.poppins(color: Colors.red,fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

           ],

         ),
      );
  }
}
