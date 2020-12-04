import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductProvider _product =
        Provider.of<ProductProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: _product.id,
            );
          },
          child: Image.network(_product.imageUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.9),
          leading: Consumer<ProductProvider>(
            builder: (BuildContext context, product, Widget child) {
              return IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavorite();
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
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<CartListProvider>(
            builder: (BuildContext context, cart, Widget child) {
              return IconButton(
                icon: Icon(cart.isProductAddedToCart(_product.id)
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined),
                color: Theme.of(context).accentColor,
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
        ),
      ),
    );
  }
}
