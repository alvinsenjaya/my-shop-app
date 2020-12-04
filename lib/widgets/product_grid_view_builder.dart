import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class ProductGridViewBuilder extends StatelessWidget {
  final bool _showFavoriteOnly;

  const ProductGridViewBuilder(this._showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final _productList = _showFavoriteOnly
        ? Provider.of<ProductListProvider>(context).favoriteItems
        : Provider.of<ProductListProvider>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _productList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: ((context, i) {
        return ChangeNotifierProvider.value(
          value: _productList[i],
          child: ProductListItem(),
        );
      }),
    );
  }
}
