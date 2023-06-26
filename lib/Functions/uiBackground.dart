import 'package:flutter/material.dart';


uiBackground(context){
  return
    Opacity(
        opacity: 0.1,
        child: Image.asset('img/gro_icon_bg.png',width: 180,color: Theme.of(context).primaryColorDark,));
}
