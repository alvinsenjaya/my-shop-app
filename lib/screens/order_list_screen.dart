import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/order_list_provider.dart';
import 'package:my_shop_app/widgets/main_drawer.dart';
import 'package:my_shop_app/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final OrderListProvider _orders =
        Provider.of<OrderListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: MainDrawer(),
      body: _orders.items.length == 0
          ? Center(
              child: Text(
                'Your order list is empty',
              ),
            )
          : ListView.builder(
              itemCount: _orders.items.length,
              itemBuilder: (context, i) {
                return OrderListItem(_orders.items[i]);
              },
            ),
    );
  }
}
