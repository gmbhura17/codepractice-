import 'package:flutter/material.dart';

import 'Api/InsertPage.dart';
import 'Api/ViewPage.dart';
import 'FakeApi.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home of Api's"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.greenAccent,
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            ElevatedButton(
              onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> InsertPage()));
                // Navigator.of(context).pop();
              },
              child: Text("InsertPage"),
            ),
            ElevatedButton(
              onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewPage()));
                //  Navigator.of(context).pop();
              },
              child: Text("ViewPage"),
            ),
            ElevatedButton(
              onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FakeApi()));
                // Navigator.of(context).pop();
              },
              child: Text("FakeApi3"),
            ),
          ],
        ),
      ),
    );
  }
}
