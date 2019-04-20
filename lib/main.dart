import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './provide/details_info.dart';
import './provide/cart.dart';
import './provide/currentIndex.dart';

void main(){
  var providers =Providers();
  
  var counter =Counter(); 
  var childCategory = ChildCategory();
  var categoryGoodsListProvide= CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndex = CurrentIndexProvide();

  providers
   ..provide(Provider<Counter>.value(counter))
   ..provide(Provider<ChildCategory>.value(childCategory))
   ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
   ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
   ..provide(Provider<CartProvide>.value(cartProvide))
   ..provide(Provider<CurrentIndexProvide>.value(currentIndex));
   
  runApp(ProviderNode(child: MyApp(),providers: providers,));
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: 'MyShop',
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}