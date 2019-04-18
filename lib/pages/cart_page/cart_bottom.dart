import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          _selectAllBtn(),
          _allPriceArea(),
          _goButton()
        ],
      ),
    );
  }

  //全选按钮
  Widget _selectAllBtn(){
    return Container(
      width: ScreenUtil().setWidth(180),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: true,
            activeColor: Colors.pink,
            onChanged: (bool val){},
          ),
          Text('全选')
        ],
      ),
    );
  }

  // 合计区域
  Widget _allPriceArea(){

    return Container(
      width: ScreenUtil().setWidth(400),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(250),
                child: Text(
                  '合计:',
                  style:TextStyle(
                    fontSize: ScreenUtil().setSp(32)
                  )
                ), 
              ),
              Container(
                 alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(140),
                child: Text(
                  '￥1922',
                  style:TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    color: Colors.red,
                  )
                ),
                
              )
             
              
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(400),
            alignment: Alignment.center,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                color: Colors.black38,
                fontSize: ScreenUtil().setSp(22)
              ),
            ),
          )
          
        ],
      ),
    );
  }

  //结算按钮
  Widget _goButton(){
    
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child:InkWell(
        onTap: (){},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
             color: Colors.red,
             borderRadius: BorderRadius.circular(3.0)
          ),
          child: Text(
            '结算(6)',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ) ,
    );
  }
}