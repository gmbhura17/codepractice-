import 'package:flutter/cupertino.dart';

import 'StyleResources.dart';

class MyButton extends StatelessWidget {

  var btntext ="";
  GestureTapCallback onclick;
  MyButton({required this.btntext,required this.onclick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        decoration: BoxDecoration(
            color: StyleResources.btncolor,
            borderRadius: BorderRadius.circular(20.0)
        ),
        margin: EdgeInsets.all(10.0),

        width: MediaQuery.of(context).size.width,
        height: 60.0,
        alignment: Alignment.center,
        child: Text(btntext,style: StyleResources.btntext,),

      ),
    );
  }
}
