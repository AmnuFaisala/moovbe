import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'buslist.dart';

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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible=true;
  bool _usernamevalidate = false;
  bool _passwordvalidate = false;

  @override
  void initState(){
    super.initState();
    passwordVisible=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
             body: Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Container(
                  width: 400,
                  height: 300,
                  color: Colors.black,
                  child: ClipPath(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.red,
                    ),
                    clipper: CustomClipPath(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left:30.0,top:150,right:50,bottom:20),
                    child: Column(
                      children: [
                        Text('Welcome',style: GoogleFonts.cabin(color: Colors.white,fontSize: 39,fontWeight: FontWeight.bold),),
                        Text('Manage your Bus and Drivers',style: GoogleFonts.poppins(color: Colors.white,fontSize: 13),),
                      ],
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,top:350,right:30,bottom:0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: usernameController,
                    decoration: InputDecoration(
                      errorText: _usernamevalidate ? 'Value Can not Be Empty' : null,
                      filled: true,
                      fillColor: Color(0xFFEBEDEF),
                      hintText: "Enter username",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: myinputborder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,top:440,right:30,bottom:0),
                  child: TextField(
                    obscureText: passwordVisible,
                    textAlign: TextAlign.center,
                    controller: passwordController,
                    decoration: InputDecoration(
                      errorText: _passwordvalidate ? 'Value Can not Be Empty' : null,
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      filled: true,
                      fillColor: Color(0xFFEBEDEF),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: myinputborder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,top:680,right:30,bottom:0),
                  child: SizedBox(
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
                        onPressed:login,
                      child: Text("Login",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16),
                    ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> login() async{
    final pref=await SharedPreferences.getInstance();
    String login_id;
    String temp;
    if(usernameController.text.isEmpty ? _usernamevalidate = true : _usernamevalidate = false){
      setState(() {
        _usernamevalidate = true;
      });
    }else{
      setState(() {
        _usernamevalidate = false;
      });
    }
    if(passwordController.text.isEmpty ? _passwordvalidate = true : _passwordvalidate = false){
      setState(() {
        _passwordvalidate = true;
      });
    }else{

      try{

        String ip= pref.getString("IP").toString();

        var data = await http.post(Uri.parse("http://"+ip+":3500/login"),body: {"username":usernameController.text.toString(),"password":passwordController.text.toString()});
        var jsondata = json.decode(data.body);
        print(jsondata);
        temp=jsondata['status'].toString();
        var type=jsondata['type'].toString();
        login_id=jsondata['lid'].toString();
        await pref.setString('from_id', login_id);

        if(temp=="ok"){
          Navigator.push(context, MaterialPageRoute(builder:(_)=>BusList(title: '',) ));
        }
        else{
          // Navigator.push(context, MaterialPageRoute(builder:(_)=>SignupPage(title: '',) ));
        }
      }catch(e){
        print("Error ------------------- "+e.toString());

      }
      setState(() {
        _passwordvalidate = false;
      });
    }
    usernameController.clear();
    passwordController.clear();
  }
}
class CustomClipPath extends CustomClipper<Path> {
  // var radius=1.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 4, 0);
    path.lineTo(size.width - 100, size.height);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

OutlineInputBorder myinputborder(){
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none
  );
}