import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/screens/user_product_list_add_edit_screen.dart';
import 'package:my_shop_app/widgets/main_drawer.dart';
import 'package:my_shop_app/widgets/user_product_list_manager_item.dart';
import 'package:provider/provider.dart';

class UserProductListManagerScreen extends StatelessWidget {
  static const routeName = '/user-products-manager';

  @override
  Widget build(BuildContext context) {
    final List<ProductProvider> _products =
        Provider.of<ProductListProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                UserProductAddEditScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, i) {
          return ChangeNotifierProvider.value(
            value: _products[i],
            child: UserProductListManagerItem(),
          );
        },
      ),
    );
  }
}
