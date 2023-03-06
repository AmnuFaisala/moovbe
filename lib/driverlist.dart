import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'adddriver.dart';

class DriverList extends StatefulWidget {
  const DriverList({super.key, required this.title});

  final String title;

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title:Text('Driver List',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body:Stack(
          children: [
            Container(
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
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(onTap: (){},
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0,right: 8,top: 25),
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
                                      child: CircleAvatar(
                                        radius: 28,
                                         // backgroundImage: NetworkImage("https://www.shutterstock.com/image-photo/happy-woman-driving-car-smiling-260nw-1724743738.jpg"),
                                        child: ClipOval(
                                        child: Image.asset("assets/images/drivers.jpg",
                                          width: 70,
                                          height: 60,
                                          fit: BoxFit.fill))
                                      )
                                    ),
                                  title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data[index].driver_name.toString()),
                                        Row(
                                          children: [
                                            Text("Licn no: "),
                                            Text(snapshot.data[index].license_number.toString(),style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                      ]
                                  ),
                                  trailing: ElevatedButton(onPressed: ()async{
                                    delete(snapshot.data[index].driver_id);
                                  },
                                      child: Text("Delete",style: GoogleFonts.poppins(color: Colors.white,fontSize: 12),)
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            //   ],
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 300,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.red,),),
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>AddDriver(title: "",)));
                    },
                    child: Text("Add Driver",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
  Future<List<driverview>>inview() async{
    final pref = await SharedPreferences.getInstance();
    String ip = pref.getString("IP").toString();
    // print("ip");
    // print(ip);
    var data = await http.post(Uri.parse("http://" + ip + ":3500/view_driverlist"));
    // print(ip);
    // print(data);
    // print("checking........");

    var jsonData = json.decode(data.body.toString());
    print(jsonData);
    // print("staaattusssee");
    print(jsonData["status"]);
    // print(jsonData);
    List<driverview> view_data = [];
    for (var i in jsonData["data"]) {
      driverview sg = driverview(i["driver_id"].toString(),i["driver_name"].toString(),i["license_number"].toString(),i["driver_phone"].toString());
      view_data.add(sg);
      print("length  : ${view_data.length}");

      // print(view_data);
    }
    return view_data;
  }

  Future<void> delete(String driver_id) async{


    final pref=await SharedPreferences.getInstance();
    String ip= pref.getString("IP").toString();

    var data = await http.post(Uri.parse("http://"+ip+":3500/delete_data"),body:{"driver_id":driver_id});
    var jsondata = json.decode(data.body);
    print(jsondata);
    setState(() {
      Navigator.pushReplacement((context), MaterialPageRoute(builder: (context)=>DriverList(title: '')));
    });


  }
}

class driverview {
  late final String driver_id;
  late final String driver_name;
  late final String license_number;
  late final String driver_phone;
  driverview(this.driver_id,this.driver_name,this.license_number,this.driver_phone);
}
