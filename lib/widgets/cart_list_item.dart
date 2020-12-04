import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListProvider _cart = Provider.of<CartListProvider>(context);
    final CartItemProvider _cartItem = Provider.of<CartItemProvider>(context);
    final ProductProvider _product = Provider.of<ProductProvider>(context);

    return Dismissible(
      key: ValueKey(_cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
      ),
      onDismissed: (direction) {
        _cart.removeFromCartById(_cartItem.id);
      },
      confirmDismiss: (direction) {
        return buildShowConfirmRemoveItemDialog(context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_product.imageUrl, fit: BoxFit.cover),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(child: Text('Quantity: ${_cartItem.quantity}')),
                FittedBox(
                    child: Text(
                        'Price: IDR ${_product.price.toStringAsFixed(0)}')),
                FittedBox(
                    child: Text(
                        'Total: IDR ${_cartItem.totalPrice.toStringAsFixed(0)}')),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red[900],
              ),
              onPressed: () {
                buildShowConfirmRemoveItemDialog(context).then((isConfirmed) {
                  if (isConfirmed) {
                    _cart.removeFromCartById(_cartItem.id);
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> buildShowConfirmRemoveItemDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure to remove selected item from cart?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
