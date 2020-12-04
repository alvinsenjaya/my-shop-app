import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop_app/providers/order_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:provider/provider.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem _order;

  const OrderListItem(this._order);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('IDR ${widget._order.amount.toStringAsFixed(0)}'),
            subtitle: Text(
                DateFormat('dd MMM yyyy, hh:mm').format(widget._order.date)),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              height: min(widget._order.cart.length * 20.0 + 20.0, 150.0),
              child: ListView.builder(
                itemCount: widget._order.cart.length,
                itemBuilder: (context, i) {
                  final ProductProvider _product =
                      Provider.of<ProductListProvider>(context)
                          .findById(widget._order.cart[i].productId);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _product.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget._order.cart[i].quantity.toString()} x IDR ${_product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
