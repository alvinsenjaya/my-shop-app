import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/screens/user_product_list_add_edit_screen.dart';
import 'package:provider/provider.dart';

class UserProductListManagerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductProvider _product = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        ListTile(
          title: Text(_product.title),
          subtitle: Text(
            'IDR ${_product.price.toStringAsFixed(0)}',
            textAlign: TextAlign.start,
          ),
          leading: Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(_product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      UserProductAddEditScreen.routeName,
                      arguments: _product.id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                  onPressed: () {
                    Provider.of<ProductListProvider>(context, listen: false)
                        .deleteById(_product.id);
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
