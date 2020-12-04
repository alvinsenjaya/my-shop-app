import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';
import 'package:my_shop_app/screens/cart_list_screen.dart';
import 'package:my_shop_app/widgets/badge.dart';
import 'package:my_shop_app/widgets/main_drawer.dart';
import 'package:my_shop_app/widgets/product_grid_view_builder.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  FavoriteOnly,
  All,
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Consumer<CartListProvider>(
            builder: (
              BuildContext context,
              CartListProvider cart,
              Widget child,
            ) {
              return Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartListScreen.routeName);
                  },
                ),
                value: cart.items.length.toString(),
                color: Theme.of(context).primaryColor,
              );
            },
          ),
          PopupMenuButton(
            onSelected: (FilterOptions _filterOptions) {
              setState(() {
                if (_filterOptions == FilterOptions.FavoriteOnly) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Show Favorites'),
                  value: FilterOptions.FavoriteOnly,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ];
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ProductGridViewBuilder(_showFavoriteOnly),
    );
  }
}
