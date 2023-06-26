import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Insert extends StatefulWidget {

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {

  TextEditingController _student = TextEditingController();
  TextEditingController _roll = TextEditingController();
  var grpvalue = "A";
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
          children: [
            ElevatedButton(onPressed: ()   async{
              var student = _student.text.toString();
              var roll = _roll.text.toString();
              var division = grpvalue;
              await FirebaseFirestore.instance.collection("Students").add({
                "student":student,
                "roll no":roll,
                "division":division
              }).then((value) {
                print("STUDENT Record DalDIYA (Nakhdiya)");
                Navigator.of(context).pop();
                _student.text="";
                _roll.text="";
                grpvalue="";

              });

            },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),child: Text("Add"   ,
                  style: TextStyle(color: Colors.lightGreen),)),
          ],
        )
    );
  }
}
