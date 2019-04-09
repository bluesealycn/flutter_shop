import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      //padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: (){

            },
            child: Container(
              width: ScreenUtil().setWidth(170),
              alignment: Alignment.center,
              color:Colors.white,
              child: Icon(
                Icons.shopping_cart,
                color:Colors.red,
                size:28
              ),
            )
          ),

          InkWell(
            onTap: (){

            },
            child: Container(
              width: ScreenUtil().setWidth(290),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                "加入购物车",
                style:TextStyle(
                  color: Colors.white
                )
              )
            )
          ),
          InkWell(
            onTap: (){

            },
            child: Container(
              width: ScreenUtil().setWidth(290),
              alignment: Alignment.center,
              color: Colors.red,
              child:  Text(
                "立即购买",
                style:TextStyle(
                  color: Colors.white
                )
              )
            )
          )

        ],
      ),
      
    );
  }
}