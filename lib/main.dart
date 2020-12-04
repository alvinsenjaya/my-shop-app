import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/providers/order_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/screens/cart_list_screen.dart';
import 'package:my_shop_app/screens/order_list_screen.dart';
import 'package:my_shop_app/screens/product_detail_screen.dart';
import 'package:my_shop_app/screens/product_list_screen.dart';
import 'package:my_shop_app/screens/user_product_list_add_edit_screen.dart';
import 'package:my_shop_app/screens/user_product_list_manager_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return ProductListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return CartListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return OrderListProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.lightGreenAccent,
          fontFamily: 'Lato',
        ),
        home: ProductListScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              ProductDetailScreen(ModalRoute.of(context).settings.arguments),
          CartListScreen.routeName: (context) => CartListScreen(),
          OrderListScreen.routeName: (context) => OrderListScreen(),
          UserProductListManagerScreen.routeName: (context) =>
              UserProductListManagerScreen(),
          UserProductAddEditScreen.routeName: (context) =>
              UserProductAddEditScreen(
                  ModalRoute.of(context).settings.arguments),
        },
      ),
    );
  }
}
