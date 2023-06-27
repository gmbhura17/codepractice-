import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepractice/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthPage extends StatefulWidget {

  @override
  State<GoogleAuthPage> createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  // var name="";
  // var emailid="";
  // var photo="";
  // var googleid="";
  // getdata() async
  // {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState((){
  //     name = prefs.getString("Name")!;
  //     emailid = prefs.getString("Email")!;
  //     photo = prefs.getString("Photo")!;
  //     googleid = prefs.getString("GoogleID")!;
  //   });
  // }
  // @override
  // void initState() {
  //   // TODO: implement initstate
  //   super.initState();
  //   getdata();
  // }
  var photoURL="";
  var name="";
  var email="";
  var uid="";

  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      photoURL = prefs.getString("Photo").toString();
      name = prefs.getString("Name").toString();
      email = prefs.getString("Email").toString();
      uid = prefs.getString("GoogleID").toString();
      print("Emaillll : "+email);
    });
  }
  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: GestureDetector(
                onTap: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>HomePage())
                  );
                },
                child: Icon(Icons.login_outlined,size: 35)
            ),
          )
        ],
        title: Column(
          children: [
            Text("Email Verified - "+((name!=""
                // ? name!=""
            )?name:"Guest"),style: TextStyle(fontSize: 16),),
          ],
        ),
      ),

      body: (email!="")?StreamBuilder(
          stream: FirebaseFirestore.instance.collection("GoogleAuth").where("Emailid",isNotEqualTo: email).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData)
            {
              if(snapshot.data!.size<=0)
              {
                return Center(
                  child: Text("No Google auth found"),
                );
              }
              else{
                return Container(
                  color: Colors.lightBlueAccent,
                  child: ListView(
                    children: snapshot.data!.docs.map((document){
                      return Container(
                        color: Colors.cyanAccent,
                        child: Card(
                          elevation: 10,
                          child: Container(
                            color: Colors.greenAccent,
                            child: ListTile(
                              onTap: (){
                                // Navigator.of(context).push(
                                //     MaterialPageRoute(builder: (context)=> Chats(
                                //       txtname: document["Name".toString()],
                                //       txtemail: document["Emailid".toString()],
                                //       txtphoto: document["Photo".toString()],
                                //       receiverid: document.id.toString(),
                                //     ) ));
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,

                                child: Image.network(document["Photo"].toString()),
                              ),

                              // trailing: Image.network(document["Photo"].toString()),
                              title: Text(document["Emailid"].toString(),style: TextStyle(fontSize: 20),),
                              subtitle: Column(
                                children: [

                                  Text(document["Name"].toString(),style: TextStyle(fontSize: 17),),
                                  Text(document["Gid"].toString(),style: TextStyle(fontSize: 11),),

                                  // Text(document["Name"].toString(),style: TextStyle(fontSize: 20),),
                                  // Text(document["Gid"].toString()),
                                // Text(document["Emailid"].toString()),
                                ],
                              ),

                            ),

                          ),
                        ),

                      );
                    }).toList(),
                  ),
                );
              }
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ):CircularProgressIndicator(),
    );
  }
}
