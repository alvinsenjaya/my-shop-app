import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  final String _productId;

  const ProductDetailScreen(this._productId);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductProvider _product =
        Provider.of<ProductListProvider>(context).findById(widget._productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(_product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    _product.toggleFavorite();
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _product.isFavorite
                            ? 'Item added to favorite'
                            : 'Item removed from favorite',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(_product.imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Text(
              'Price',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
              softWrap: true,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Text(
              'IDR ${_product.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
              softWrap: true,
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Text(
              'Description',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
              softWrap: true,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Text(
              _product.description,
              textAlign: TextAlign.start,
              softWrap: true,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
      floatingActionButton: Consumer<CartListProvider>(
        builder: (BuildContext context, cart, Widget child) {
          return FloatingActionButton(
            child: Icon(cart.isProductAddedToCart(_product.id)
                ? Icons.shopping_cart
                : Icons.shopping_cart_outlined),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              cart.addToCart(new CartItemProvider(
                id: Uuid().v4(),
                productId: _product.id,
                quantity: 1,
              ));
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item added to cart',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItemByProductId(_product.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
