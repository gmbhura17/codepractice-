import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Functions/Containers.dart';

class FakeApi extends StatefulWidget {

  @override
  State<FakeApi> createState() => _FakeApiState();
}

class _FakeApiState extends State<FakeApi> {
  Future<List>? alldata;

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
        title: Text("Fake APi's"),
      ),
      body: FutureBuilder(
        future: alldata,
        builder: (context,snapshots)
        {
          if(snapshots.hasData)
          {
            if(snapshots.data!.length<=0)
            {
              return Center(
                child: Text("No Data"),
              );
            }
            else
            {
              return ListView.builder(
                itemCount: snapshots.data!.length,
                itemBuilder: (context,index)
                {
                  return
                    Column(
                      children: [
                        Container(
                          child: Image.network(snapshots.data![index]["image"].toString(),height: 100,width: 100,),
                        ),
                        Text(snapshots.data![index]["price"].toString(),),
                        Column(
                          children: [
                            homeScreenContainer(const Color(0xFFE2F5FF), "img/gro_strabery.png",snapshots.data![index]["name"].toString()),
                          ],
                        )

                      ],
                    );
                  //   ListTile(
                  //   leading: Image.network(snapshots.data![index]["image"].toString()),
                  //   title: Column(
                  //     children: [
                  //       Text(snapshots.data![index]["title"].toString()),
                  //       Text(snapshots.data![index]["price"].toString()),
                  //     ],
                  //   ),
                  //   subtitle: Text(snapshots.data![index]["rating"]["rate"].toString()),
                  // );
                },
              );
            }
          }
          else
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
