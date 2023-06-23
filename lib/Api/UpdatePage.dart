import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ViewPage.dart';

class UpdatePage extends StatefulWidget {
  var updateid="";
  UpdatePage({required this.updateid});
  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  TextEditingController _product  = TextEditingController();
  TextEditingController _price  = TextEditingController();
  TextEditingController _quantity  = TextEditingController();


  fetchProducts() async{
    //get single product -api  (post)
    Uri url= Uri.parse("http://picsyapps.com/studentapi/getSingleProduct.php");
    Map<String,String> params = {
      "pid":widget.updateid
    };
    var response = await http.post(url,body: params);
    if(response.statusCode==200)
    {
      var body = response.body.toString();
      var json = jsonDecode(body);
      _product.text = json["data"]["pname"].toString();
      _price.text = json["data"]["price"].toString();
      _quantity.text = json["data"]["qty"].toString();
    }
    else
    {
      print("API Error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api's Update...(!)"),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            // Text("Product :"),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _product ,
                // obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product',
                    hintText: 'Enter Your Product'
                ),
              ),

            ),
            SizedBox(
              height: 60,
            ),
            // Text("Price :"),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _price,
                // obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Enter Your price'
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            // Text("Quantity :"),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _quantity ,
                // obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                    hintText: 'Enter your quantity'

                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            GestureDetector(
              onTap: () async{
                var name = _product.text.toString();
                var q = _quantity.text.toString();
                var p = _price.text.toString();

                Uri url = Uri.parse("http://picsyapps.com/studentapi/updateProductNormal.php");

                Map<String,String> params = {
                  "pname":name,
                  "qty":q,
                  "price":p,
                  "pid":widget.updateid
                };

                var response = await http.post(url,body: params);
                if(response.statusCode==200)
                {
                  var body = response.body.toString();
                  var json= jsonDecode(body);
                  if(json["status"]=="true")
                  {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>ViewPage())
                    );
                  }
                  else
                  {
                    print("Error");
                  }
                }
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text('Submit New APi', style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
