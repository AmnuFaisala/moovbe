import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
//       home: const HomePage(title: ''),
//       // routes: {
//       //   'login' : (ctx){
//       //     return LoginPage(title: '',);
//       //   },
//       // },
//     );
//   }
// }

class BusList extends StatefulWidget {
  const BusList({super.key, required this.title});

  final String title;

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
 String buscount = " ";
  _BusListState(){
    inview();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(text: "moov",style: GoogleFonts.poppins(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              children:[
                TextSpan(text: "be",style: GoogleFonts.poppins(color: Colors.yellowAccent,fontSize: 25,fontWeight: FontWeight.bold),)
              ]
          ),

        ),
          centerTitle: true,
      ),
      body:Stack(
        // physics: BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 163,
                    height: 200,
                    child: InkWell(onTap: (){},
                      child: Card(
                        margin: EdgeInsets.only(top:20,left: 5),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:10.0,left: 20),
                              child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Bus',style: GoogleFonts.poppins(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                  Text('Manage your Bus',style: GoogleFonts.poppins(color: Colors.white,fontSize: 12),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0,top: 80),
                              child: Image.asset('assets/images/bus.png',width: 300,
                                  height: 150,),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 163,
                    height: 200,
                    child: InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>DriverList(title: "",)));
                    },
                      child: Card(
                        margin: EdgeInsets.only(top:20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.black,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:10.0,left: 20),
                              child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver',style: GoogleFonts.poppins(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                  Text('Manage your Driver',style: GoogleFonts.poppins(color: Colors.white,fontSize: 12),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0,top: 80),
                              child: Image.asset('assets/images/driver.png',width: 300,
                                height: 150,),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:225.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: FutureBuilder(
                  future: inview(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print("snapshot" + snapshot.toString());
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text(" Loading........"),
                        ),
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(onTap: (){},
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  // onLongPress: () {
                                  //
                                  // },
                                  leading:Container(
                                    color: Color(0xFFEBEDEF),
                                      child: Image.asset("assets/images/bus.png")),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data[index].bus_name.toString()),
                                            Text(snapshot.data[index].bus_model.toString(),style: TextStyle(fontSize: 12),),
                                        Text(buscount),
                                      ]
                                  ),
                                    trailing: ElevatedButton(onPressed: (){},
                                    child: Text("Manage",style: GoogleFonts.poppins(color: Colors.white,fontSize: 12),)
                                    ),
                                  ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      )
    );
  }
  Future<List<userview>>inview() async{
    final pref = await SharedPreferences.getInstance();
    String ip = pref.getString("IP").toString();
    var data = await http.post(Uri.parse("http://" + ip + ":3500/view_buslist"));
      var jsonData = json.decode(data.body.toString());

     buscount = jsonData['count'].toString();
    setState(() {
      buscount=jsonData['count'].toString();
    });


    print(jsonData);
    // print("staaattusssee");
    print(jsonData["status"]);
    // print(jsonData);
    List<userview> view_data = [];
    for (var i in jsonData["data"]) {
      userview sg = userview(i["id"].toString(),i["bus_model"].toString(),i["bus_name"].toString(),i["bus_number"].toString(),i["bus_time"].toString());
      view_data.add(sg);
      // print("length  : ${view_data.length}");

    // print(view_data);
    }
    return view_data;
  }
}

class userview {
  late final String id;
  late final String bus_model;
  late final String bus_name;
  late final String bus_number;
  late final String bus_time;
  userview(this.id,this.bus_model,this.bus_name,this.bus_number,this.bus_time);
}
