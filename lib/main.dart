import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String shortlink = "";
  TextEditingController urlcontroller = TextEditingController();
  getData() async {
    print(urlcontroller.text);
    var url = 'https://api.shrtco.de/v2/shorten?url=${urlcontroller.text}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    setState(() {
      shortlink = result['result']['short_link'];
    });
    // print(shortlink);
  }

  copy(String link) {
    FlutterClipboardManager.copyToClipBoard(link).then((value) {
      SnackBar snackbar = SnackBar(
        content: Text('link copied !'),
        duration: Duration(seconds: 2),
      );
      _globalKey.currentState.showSnackBar(snackbar);
    });
  }

  buildRow(String title, String data, bool original) {
    return SingleChildScrollView(
      child: original
          ? Container(
              alignment: Alignment.center,
              child: Text(
                data,
                // style: GoogleFonts.montserrat(
                //     fontSize: 20, fontWeight: FontWeight.w700),
              ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  // style: GoogleFonts.montserrat(
                  //     fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  data,
                  // style: GoogleFonts.montserrat(
                  //     fontSize: 20, fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () => copy(shortlink),
                    child: Icon(Icons.content_copy))
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello there',
                        // style: GoogleFonts.montserrat(
                        //     fontSize: 30, color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: urlcontroller,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[500],
                              prefixIcon: Icon(Icons.search),
                              labelText: "Paste your url here !",
                              // labelStyle: GoogleFonts.montserrat(
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.w700,
                              // ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: getData,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Short Now ',
                      // style: GoogleFonts.montserrat(
                      //     fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    buildRow("Shorted Link", shortlink, false),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
