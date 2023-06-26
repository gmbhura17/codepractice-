import 'package:flutter/material.dart';

import '../FakeApi.dart';
import 'InsertPage.dart';
import 'ViewPage.dart';

class Drawer extends StatefulWidget {

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body:  Container(
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
