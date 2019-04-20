import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import '../../provide/details_info.dart';
import '../../provide/currentIndex.dart';

class DetailsBottom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId= goodsInfo.goodsId;
    var goodsName =goodsInfo.goodsName;
    var count =1;
    var price =goodsInfo.presentPrice;
    var images= goodsInfo.image1;

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(90),
      //padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async{
              //--------------关键代码----------start-----------
              Provide.value<CurrentIndexProvide>(context).changeIndex(2);
              Navigator.pop(context);
              //-------------关键代码-----------end--------
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
            onTap: () async{
              await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
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
            onTap: () async{
              await Provide.value<CartProvide>(context).remove();
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