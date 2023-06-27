import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepractice/Api/InsertPage.dart';
import 'package:codepractice/Api/ViewPage.dart';
import 'package:codepractice/Auth/GoogleAuthPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/LoginPage.dart';
import 'Functions/Containers.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //------ google auth ------------
  FirebaseAuth auth = FirebaseAuth.instance;
  var displayName="";
  var email="";
  var photoURL="";
  var uid="";

  //----------- Api -----------------
  Future<List>? alldata;
//https://jsonplaceholder.typicode.com/todos/1
  Future<List> getdata() async
  {
    Uri url = Uri.parse("https://fakestoreapi.com/products");
    var response = await http.get(url);
    if(response.statusCode==200)
    {
      var body = response.body.toString();
      var json = jsonDecode(body);
      return json;
    }
    else
    {
      return[];
    }
  }



  @override
  void initState() {
    super.initState();
    setState((){
      alldata =  getdata();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(

        // -------------------- Log-out (Alert Dialog --------------------------------
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Home Page"),
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: IconButton(
                  onPressed: () {
                    AlertDialog alert = new AlertDialog(
                      title: Center(child: Text("ALert !")),
                      content: Text("You Want To Logout !"),
                      actions: [
                        Row(
                          children: [
                            TextButton(onPressed: (){  Navigator.of(context).pop();}, child: Text("Cancel")),
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> LoginPage())
                              );
                            }, child: Text("LogOut")),
                          ],
                        )
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        });
                  },
                  icon: Icon(Icons.logout)),
            ),
          ],
        ),
      ),


      drawer: Drawer(
        child: Column(


          children: [
            SizedBox(height: 100,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => InsertPage()));
              },
              child: Text("InsertPage"),
            ),
            ElevatedButton(
              onPressed: (){  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPage()));}, child: Text("ViewPage"),
            ),
            // GestureDetector(
            //   onTap: (){
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Upd()));
            //   },
            // )
          ],
        ),
      ),


      body: Container(
        color: Colors.black,

        child: Expanded(
          child: Column(
            children: [

              //------------------------- Column-1 -----------------------------------

              Column(
                children: [
                  Container(
                    color: Colors.cyanAccent,
                    height: 240,
                    child: FutureBuilder(
                        future: alldata,
                        builder: (context,Snapshots)
                        {
                          if(Snapshots.hasData){
                            if(Snapshots.data!.length<=0){
                              return Center(
                                child: Text("No Data Found . . 404"),
                              );
                            }
                            else{
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Snapshots.data!.length,
                                  itemBuilder: (context,index)
                                  {
                                    return
                                        Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Text("Fake-Ai's Data",style: TextStyle(color: Colors.blueAccent),),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Text("Products Data"),
                                            Card(
                                            elevation: 20,
                                            child: Container(
                                              // color: Colors.greenAccent,
                                              height: 150,
                                             width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: Border.all(color: Colors.black,width: 3
                                                  )
                                              ),
                                              child:Center(

                                                child: Column(

                                                  children: [
                                                    SizedBox(height: 30,),
                                                    Image.network(Snapshots.data![index]["image"].toString(),scale: 24,),
                                                    Text(Snapshots.data![index]["id"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["rating"]["rate"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["price"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["category"].toString(),style: TextStyle(fontSize: 10),),

                                                  ],
                                                ),
                                              ),
                                            ),

                                            ),
                                          ],
                                        );

                                    //------ Option 2 (Custom Widget) --------------------------------------------------------------------------------

                                        // Row(
                                        //   children: [
                                        //     Container1(const Color(0xFFE2F5FF), "img/gro_strabery.png",Snapshots.data![index]["price"].toString()),
                                        //     Container1(const Color(0xFFFFEDF3), "img/gro_strabery.png",Snapshots.data![index]["category"].toString()),
                                        //     Container1(const Color(0xFFAFE3FF), "img/gro_strabery.png",Snapshots.data![index]["id"].toString()),
                                        //   ],
                                        // );

                                  }
                              );
                            }
                          }
                          else{
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    ),
                  ),
                ],
              ),

             // --------------------------------- Gooogle Auth ------------------------------


              Column(
                children: [
                  Container(
                    color: Colors.yellowAccent,
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        GestureDetector(
                          onTap: ()async{
                            final GoogleSignIn googleSignIn = GoogleSignIn();
                            final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
                            if (googleSignInAccount != null) {
                              final GoogleSignInAuthentication googleSignInAuthentication =
                                  await googleSignInAccount.authentication;
                              final AuthCredential authCredential = GoogleAuthProvider.credential(
                                  idToken: googleSignInAuthentication.idToken,
                                  accessToken: googleSignInAuthentication.accessToken);

                              // Getting users credential
                              UserCredential result = await auth.signInWithCredential(authCredential);
                              User? user = result.user;
                              var name = user!.displayName.toString();
                              var emailId = user.email.toString();
                              var photo = user.photoURL.toString();
                              var gid = user.uid.toString();


                              SharedPreferences prefs = await SharedPreferences
                                  .getInstance();
                              prefs.setString("Name", name);
                              prefs.setString("Email", emailId);
                              prefs.setString("Photo", photo);
                              prefs.setString("GoogleID", gid);


                              await FirebaseFirestore.instance.collection("GoogleAuth").where("Emailid",isEqualTo: emailId).get().then((documents) async{
                                if(documents.size<=0)
                                {
                                  await FirebaseFirestore.instance.collection("GoogleAuth").add({
                                    "Name":name,
                                    "Emailid":emailId,
                                    "Photo":photo,
                                    "Gid":gid,
                                  }).then((document) {
                                    prefs.setString("senderid", document.id.toString());
                                    print("record inserted ");
                                    displayName="";
                                    email="";
                                    photoURL="";
                                    uid="";
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => GoogleAuthPage())
                                  );

                                }
                                else
                                {
                                  prefs.setString("senderid", documents.docs.first.id.toString());
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => GoogleAuthPage())
                                  );

                                }
                              }
                              );

                            }
                          },
                          child: Container(
                            color: Colors.deepPurple,
                            height: 45,
                            width: 220,
                            child: Center(child: Text("Google Authentication",style: TextStyle( color: Colors.white,fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),



              //------------------------------ Column 3 ----------------------------------------
              Column(
                children: [
                  Container(
                    height: 240,
                    color: Colors.deepPurple,
                    // alignment: Alignment.center,

                    child: FutureBuilder(
                        future: alldata,
                        builder: (context,Snapshots)
                        {
                          if(Snapshots.hasData){
                            if(Snapshots.data!.length<=0){
                              return Center(
                                child: Text("No Data Found . . 404"),
                              );
                            }
                            else{
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Snapshots.data!.length,
                                  itemBuilder: (context,index)
                                  {
                                    return
                                      Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          Text("Fake-Ai's Data",style: TextStyle(color: Colors.blueAccent),),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // Text("Products Data"),
                                          Card(
                                            elevation: 20,
                                            child: Container(
                                              // color: Colors.greenAccent,
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  border: Border.all(color: Colors.black,width: 3
                                                  )
                                              ),
                                              child:Center(

                                                child: Column(

                                                  children: [
                                                    SizedBox(height: 30,),
                                                    Image.network(Snapshots.data![index]["image"].toString(),scale: 24,),
                                                    Text(Snapshots.data![index]["id"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["rating"]["rate"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["price"].toString(),style: TextStyle(fontSize: 10),),
                                                    Text(Snapshots.data![index]["category"].toString(),style: TextStyle(fontSize: 10),),

                                                  ],
                                                ),
                                              ),
                                            ),

                                          ),
                                        ],
                                      );

                                    //------ Option 2 (Custom Widget) --------------------------------------------------------------------------------

                                    // Row(
                                    //   children: [
                                    //     Container1(const Color(0xFFE2F5FF), "img/gro_strabery.png",Snapshots.data![index]["price"].toString()),
                                    //     Container1(const Color(0xFFFFEDF3), "img/gro_strabery.png",Snapshots.data![index]["category"].toString()),
                                    //     Container1(const Color(0xFFAFE3FF), "img/gro_strabery.png",Snapshots.data![index]["id"].toString()),
                                    //   ],
                                    // );

                                  }
                              );
                            }
                          }
                          else{
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    ),
                  )
                ],
              ),


              //  --------------------------- Column-3 ----------------------------------




            ],
          ),
        ),

      ),
    );
  }
}



                              // return  Container1(const Color(0xFFE2F5FF), "img/flut2.jpg",Snapshots  .data![index]["category"].toString());

                              // Container(
                              //   height: 150,
                              //   width: MediaQuery.of(context).size.width,
                              //   color: Colors.blueAccent,
                              //   child: ListView(
                              //     scrollDirection: Axis.horizontal,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {
                              //                return
                              //                   Container1(const Color(0xFFE2F5FF), "img/firebase.png",Snapshots  .data![index]["category"].toString());
                              //
                              //             },
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/shoes1.jpg"),
                              //             ),
                              //           ),
                              //           SizedBox(height: 100,),
                              //           Text(
                              //             "New",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {
                              //               // FirebaseFirestore.instance.collection("flutter").add({}).then((value) => {});
                              //             },
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/flut2.jpg"),
                              //             ),
                              //           ),
                              //           Text(
                              //             "New2",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {
                              //
                              //
                              //             },
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/flut3.jpg"),
                              //             ),
                              //           ),
                              //           Text(
                              //             "New3",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {},
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/flut4.jpg"),
                              //             ),
                              //           ),
                              //           Text(
                              //             "New4",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {},
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/flut2.jpg"),
                              //             ),
                              //           ),
                              //           Text(
                              //             "New5",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           GestureDetector(
                              //             onTap: () {},
                              //             child: Container(
                              //               width: 150,
                              //               height: 130,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.greenAccent,
                              //                   borderRadius:
                              //                   const BorderRadius.all(Radius.circular(12))),
                              //               child: Image.asset("img/flut4.jpg"),
                              //             ),
                              //           ),
                              //           Text(
                              //             "New6",
                              //             style: const TextStyle(fontSize: 13, color: Colors.black),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // );


          // SizedBox(height: 50,),
          // Container(
          //   color: Colors.green,
          //   height: 130,
          //   width: 200,
          //   child: GestureDetector(
          //     onTap: () async {},
          //     child: Center(child: Text("Auth",style: TextStyle(fontSize: 30),)),
          //   ),
          // ),
          // SizedBox(height: 50,),
          // Row(
          //   children: [
          //     Container(
          //       height: 150,
          //       width: MediaQuery.of(context).size.width,
          //       color: Colors.blueAccent,
          //       child: ListView(
          //         scrollDirection: Axis.horizontal,
          //         children: [
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //                   // return  homeScreenContainer(const Color(0xFFE2F5FF), "img/gro_strabery.png",snaphots  .data[index]["name"].toString()),;
          //                 },
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut1.jpg"),
          //                 ),
          //               ),
          //               SizedBox(height: 100,),
          //               Text(
          //                 "New",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //                   // FirebaseFirestore.instance.collection("flutter").add({}).then((value) => {});
          //                 },
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut2.jpg"),
          //                 ),
          //               ),
          //               Text(
          //                 "New2",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //
          //
          //                 },
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut3.jpg"),
          //                 ),
          //               ),
          //               Text(
          //                 "New3",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {},
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut4.jpg"),
          //                 ),
          //               ),
          //               Text(
          //                 "New4",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {},
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut2.jpg"),
          //                 ),
          //               ),
          //               Text(
          //                 "New5",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {},
          //                 child: Container(
          //                   width: 150,
          //                   height: 130,
          //                   decoration: BoxDecoration(
          //                       color: Colors.greenAccent,
          //                       borderRadius:
          //                       const BorderRadius.all(Radius.circular(12))),
          //                   child: Image.asset("img/flut4.jpg"),
          //                 ),
          //               ),
          //               Text(
          //                 "New6",
          //                 style: const TextStyle(fontSize: 13, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // )

