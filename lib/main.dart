import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class rec {
  String? sitename;
  String? county;
  String? aqi;
  String? pollutant;
  String? status;
  String? so2;
  String? co;
  String? o3;
  String? o38hr;
  String? pm10;
  String? pm25;
  String? no2;
  String? nox;
  String? no;
  String? windSpeed;
  String? windDirec;
  String? publishtime;
  String? co8hr;
  String? pm25Avg;
  String? pm10Avg;
  String? so2Avg;
  String? longitude;
  String? latitude;
  String? siteid;

  rec({
    required this.sitename,
    required this.county,
    required this.aqi,
    required this.pollutant,
    required this.status,
    required this.so2,
    required this.co,
    required this.o3,
    required this.o38hr,
    required this.pm10,
    required this.pm25,
    required this.no2,
    required this.nox,
    required this.no,
    required this.windSpeed,
    required this.windDirec,
    required this.publishtime,
    required this.co8hr,
    required this.pm25Avg,
    required this.pm10Avg,
    required this.so2Avg,
    required this.longitude,
    required this.latitude,
    required this.siteid,});

  factory rec.fromJson(Map<String, dynamic> json) {
    return rec(
        sitename: json['sitename'],
        county: json['county'],
        aqi: json['aqi'],
        pollutant: json['pollutant'],
        status: json['status'],
        so2: json['so2'],
        co: json['co'],
        o3: json['o3'],
        o38hr: json['o3_8hr'],
        pm10: json['pm10'],
        pm25: json['pm2.5'],
        no2: json['no2'],
        nox: json['nox'],
        no: json['no'],
        windSpeed: json['wind_speed'],
        windDirec: json['wind_direc'],
        publishtime: json['publishtime'],
        co8hr: json['co_8hr'],
        pm25Avg: json['pm2.5_avg'],
        pm10Avg: json['pm10_avg'],
        so2Avg: json['so2_avg'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        siteid: json['siteid']);
  }
}

Future<List<rec>> getData1(String url) async {
  var response = await http.get(Uri.parse(url));
  if (response.statusCode==200) {
    dynamic x=jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> x1=x['records'];
    List<rec> items=x1.map((i)=>rec.fromJson(i)).toList();
    return items;
  }
  else throw Exception('Failed to load data!');
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Example 2',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String url1='https://data.epa.gov.tw/api/v2/aqx_p_432?offset=0&limit=1000&api_key=eef8b608-4742-4675-b462-d6f755c0e49d';
  Future<List<rec>> response=getData1(url1);
  var dropDownValue;
  List<rec> x2=[], res1=[];

  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      appBar: AppBar(title: Text('Flutter空品數值APP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top:20),
                  alignment: Alignment.center,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: FutureBuilder<List<rec>> (
                      future: response,
                      builder: (context, abc) {
                        if (abc.hasData) {
                          x2=abc.data!;
                          List<String> res=[];
                          x2.forEach((i)=> { if(!res.contains(i.county)) res.add(i.county!) });
                          return DropdownButton(
                            hint: Text('請選擇縣市'),
                            value: dropDownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropdownColor: Colors.brown[50],
                            items: res.map((i) {
                              return DropdownMenuItem(value:i, child: Text(i));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                dropDownValue=newValue;
                                res1=[];
                                x2.forEach((i)=> { if (i.county==dropDownValue) res1.add(i)});
                              });
                            },
                          );
                        }
                        else if (abc.hasError) {
                          return Text('${abc.error}');
                        }
                        return CircularProgressIndicator();
                      }
                  ),
                ),
              ],
            ),
            SizedBox(height:30),
            Container(
              height: h,
              child: ListView(
                children:
                res1.map((i)=>Card(color: Colors.purple.shade100,
                  child: ListTile(
                    leading: Text(i.county!,),
                    title: Center(child: Text(i.sitename!,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),),
                    subtitle: Center(child: Text(i.pm25!,
                      style: TextStyle(color: Colors.indigo.shade500, fontWeight: FontWeight.bold, fontSize: 15),),),
                    trailing: Text(i.aqi!,
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 20),),),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}