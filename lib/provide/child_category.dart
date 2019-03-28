import 'package:flutter/material.dart';
import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier{
    List<BxMallSubDto> childCategoryList = [];
    int childIndex = 0;       //小类高亮 索引
    String categoryId = '4';  //4--白酒类
    String subId =''; //小类ID 

    int page=1;  //列表页数，当改变大类或者小类时进行改变
    String noMoreText=''; //显示更多的标识

    //点击大类时更换
    getChildCategory(List<BxMallSubDto> list, String id){
      categoryId = id;
      childIndex = 0;

      //------------------点击大类
      page=1;
      noMoreText = ''; 
      //------------------关键代码end
      subId=''; //点击大类时，把子类ID清空
      noMoreText='';

      BxMallSubDto all=  BxMallSubDto();
      all.mallSubId='00';
      all.mallCategoryId='00';
      all.mallSubName = '全部';
      all.comments = 'null';
      childCategoryList=[all];
      childCategoryList.addAll(list);   
      notifyListeners();
    }

    //点击子类，改变子类索引
    changeChildIndex(index,String id){
       childIndex=index;
       subId=id;

       //------------------关键代码start
       page=1;
       noMoreText = ''; //显示更多的表示
       //------------------关键代码end

       notifyListeners();
    }

     //增加Page的方法f
    addPage(){
      page++;
    }

    //改变noMoreText数据  
    changeNoMore(String text){
      noMoreText=text;
      notifyListeners();
    }
}