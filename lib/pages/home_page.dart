import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  String homePageContent='正在获取数据';
  var formData = {'lon':'115.02932','lat':'35.76189'};

  int page = 1;
  List<Map> hotGoodsList=[];

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getHotGoods();
  }

  @override
  bool get wantKeepAlive =>true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                 '百酒商城',
                 style:TextStyle(fontSize: ScreenUtil().setSp(40))
               )
      ),
      body:FutureBuilder(
        future:request("homePageContext",formData:formData),
        builder: (context,snapshot){
          if(snapshot.hasData){
             var data=json.decode(snapshot.data.toString());
             List<Map> swiperDataList = (data['data']['slides'] as List).cast(); // 顶部轮播组件数
             List<Map> navigatorList = (data['data']['category'] as List).cast();
             String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
             String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
             String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话 
             List<Map> recommendList = (data['data']['recommend'] as List).cast();

             String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
             String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
             String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片

             List<Map> floor1 = (data['data']['floor1'] as List).cast();
             List<Map> floor2 = (data['data']['floor2'] as List).cast();
             List<Map> floor3 = (data['data']['floor3'] as List).cast(); 

             return EasyRefresh(

                refreshFooter: ClassicsFooter(
                  key:_footerKey,
                  bgColor:Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: '',
                  moreInfo: '加载中',
                  loadReadyText:'上拉加载....'
                ),

                child: ListView(
                  children: <Widget>[
                      SwiperDiy(swiperDataList:swiperDataList ),   //页面顶部轮播组件
                      TopNavigator(navigatorList: navigatorList),
                      AdvBanner(advertesPicture:advertesPicture),
                      LeaderPhone(leaderImage:leaderImage,leaderPhone:leaderPhone),
                      RecommendList(recommendList:recommendList),
                      FloorTitle(picture_address:floor1Title),
                      FloorContent(floorGoodsList:floor1),
                      FloorTitle(picture_address:floor2Title),
                      FloorContent(floorGoodsList:floor2),
                      FloorTitle(picture_address:floor3Title),
                      FloorContent(floorGoodsList:floor3),
                      _hotGoods(),
                      //HotGoods()
                  ],
                ),
                loadMore: ()async{
                  print('开始加载更多');
                  var formPage={'page': page};
                  await  request('homePageBelowConten',formData:formPage).then((val){
                    var data=json.decode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List ).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++; 
                    });
                  });
                },
             );
             
          }else{
            return Center(
              child: Text('加载中'),
            );
          }
        },
      )
    );
  }

  //火爆商品接口
  /*void _getHotGoods(){
    var formPage={'page': page};
    request('homePageBelowConten',formData:formPage).then((val){
      var data=json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List ).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++; 
      });
    });
  }*/

  //火爆专区标题
  Widget hotTitle= Container(
      margin: EdgeInsets.only(top: 10.0),
      padding:EdgeInsets.all(5.0),
      alignment:Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border:Border(
          bottom: BorderSide(width:0.5 ,color:Colors.black12)
        )
      ),
      child: Text('火爆专区'),
  );

  //火爆专区子项
  Widget _wrapList(){
    if(hotGoodsList.length!=0){
       List<Widget> listWidget = hotGoodsList.map((val){
          return InkWell(
            onTap:(){
              Application.router.navigateTo(context, "/detail?id=${val['goodsId']}");
            },
            child: 
            Container(
              width: ScreenUtil().setWidth(372),
              color:Colors.white,
              padding: EdgeInsets.all(5.0),
              margin:EdgeInsets.only(bottom:3.0),
              child: Column(
                children: <Widget>[
                  Image.network(val['image'],width: ScreenUtil().setWidth(375),),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow:TextOverflow.ellipsis ,
                    style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['mallPrice']}'),
                      Text(
                        '￥${val['price']}',
                        style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),
                      )
                    ],
                  )
                ],
              ), 
            )
          );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text(' ');
    }
  }

  //火爆专区组合
  Widget _hotGoods(){
    return Container(
          child:Column(
            children: <Widget>[
              hotTitle,
               _wrapList(),
            ],
          )   
    );
  }

}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {

    //print('设备宽度:${ScreenUtil.screenWidth}');
    //print('设备高度:${ScreenUtil.screenHeight}');
    //print('设备像素密度:${ScreenUtil.pixelRatio}');

    return Container(
      height: ScreenUtil().setHeight(333),//333
      width: ScreenUtil().setWidth(750),//750
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context,"/detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill),
          );
          
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item){
    return InkWell(
      onTap: (){
        //Application.router.navigateTo(context, "/detail?id=${goods['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(280),
        child: Column(
          children: <Widget>[
            Image.network(item['image'],width:ScreenUtil().setWidth(88)),//95
            Text(
              item['mallCategoryName'],
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length>10){
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),//禁止回弹
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdvBanner extends StatelessWidget {
  final String advertesPicture;

  AdvBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage,this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:'+leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

class RecommendList extends StatelessWidget {
  final List recommendList;

  RecommendList({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black12)
        )
      ),
      child: Text(
        "商品推荐",
        style:TextStyle(color: Colors.pink)
      ),
    );
  }

  //商品项
  Widget _item(context,index){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context,"/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(320),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5,color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.black12,
                fontSize:ScreenUtil().setSp(22))
            )
          ],
        ),
      ),
    );
  }

  //横向列表
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(context,index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(430),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String picture_address;

  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  Widget _goodsItem(BuildContext context, Map goods){
    return Container(
      width:ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){
          Application.router.navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods["image"]),
      ),
    );
  }

  Widget _firstRow(context){
    return Row(
      children: <Widget>[
        _goodsItem(context,floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context,floorGoodsList[1]),
            _goodsItem(context,floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context){
    return Row(
      children: <Widget>[
        _goodsItem(context,floorGoodsList[3]),
        _goodsItem(context,floorGoodsList[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context)
        ],
      ),
    );
  }
}

/*
class HotGoods extends StatefulWidget {
  
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    request("homePageBelowConten",formData:1).then((v){
      print(v);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("data"),
    );
  }
}*/