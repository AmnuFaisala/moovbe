import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'buslist.dart';
import 'driverlist.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'moovbe',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const LoginPage(title: ''),
//       routes: {
//
//       },
//     );
//   }
// }

class AddDriver extends StatefulWidget {
  const AddDriver({super.key, required this.title});

  final String title;

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController licenseController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text('Add Driver',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEBEDEF),
                      hintText: "Enter Name",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: myinputborder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEBEDEF),
                      hintText: "Enter Mobile Number",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: myinputborder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: licenseController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEBEDEF),
                      hintText: "Enter License Number",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: myinputborder(),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child:SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.red,),),
                  onPressed:save,
                  child: Text("Save",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> save() async{
    if(nameController.text.isNotEmpty && numberController.text.isNotEmpty && licenseController.text.isNotEmpty){
    try{
      final pref=await SharedPreferences.getInstance();
      String ip= pref.getString("IP").toString();
      // String login_id= pref.getString("login_id").toString();

      var data = await http.post(Uri.parse("http://"+ip+":3500/insert_driver"),body: {"driver_name":nameController.text,"license_number":licenseController.text,"driver_phone":numberController.text});
      var jsondata = json.decode(data.body);
      print(jsondata);
      // /
    }catch(e){
      print("Error ------------------- "+e.toString());
      //there is error during converting file image to base64 encoding.
    }}
    Navigator.push(context, MaterialPageRoute(builder: (_)=>DriverList(title: "",)));

    nameController.text="";
    licenseController.text="";
    numberController.text="";
  }
}


OutlineInputBorder myinputborder(){
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none
  );
}