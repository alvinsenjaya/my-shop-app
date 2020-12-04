import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/providers/order_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartListScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final CartListProvider _cart = Provider.of<CartListProvider>(context);
    final ProductListProvider _products =
        Provider.of<ProductListProvider>(context);
    final OrderListProvider _orders =
        Provider.of<OrderListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'IDR ${_cart.totalPrice.toStringAsFixed(0)}',
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    backgroundColor: Theme.of(context).primaryColorLight,
                  ),
                  FlatButton(
                    onPressed: () {
                      _orders.addOrder(OrderItem(
                        id: Uuid().v4(),
                        date: DateTime.now(),
                        amount: _cart.totalPrice,
                        cart: _cart.items,
                      ));
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Checkout Successful'),
                            content: Text(
                                'Checkout successful. Please provide your payment. Thank you.'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      _cart.clearCart();
                    },
                    child: Text(
                      'ORDER NOW',
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _cart.items.length == 0
                ? Center(
                    child: Text(
                      'Your cart is empty',
                    ),
                  )
                : ListView.builder(
                    itemCount: _cart.items.length,
                    itemBuilder: (BuildContext context, int i) {
                      ProductProvider _product =
                          _products.findById(_cart.items[i].productId);
                      return MultiProvider(providers: [
                        ChangeNotifierProvider<ProductProvider>.value(
                          value: _product,
                        ),
                        ChangeNotifierProvider<CartItemProvider>.value(
                          value: _cart.items[i],
                        ),
                      ], child: CartListItem());
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
