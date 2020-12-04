import 'package:flutter/foundation.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';

class CartItemProvider with ChangeNotifier {
  final String id;
  int quantity;
  final String productId;

  CartItemProvider({
    @required this.id,
    @required this.quantity,
    @required this.productId,
  });

  void addQuantity(int value) {
    this.quantity = this.quantity + value;
    notifyListeners();
  }

  double get price {
    return ProductListProvider()
        .items
        .firstWhere((element) => element.id == this.productId)
        .price;
  }

  double get totalPrice {
    return this.quantity * this.price;
  }
}

class CartListProvider with ChangeNotifier {
  List<CartItemProvider> _items = [];

  List<CartItemProvider> get items {
    return [..._items];
  }

  bool isProductAddedToCart(String productId) {
    return _items.any((element) => element.productId == productId);
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((element) {
      total = total + element.totalPrice;
    });
    return total;
  }

  void addToCart(CartItemProvider cartItem) {
    if (isProductAddedToCart(cartItem.productId)) {
      CartItemProvider existingCartItem = _items
          .firstWhere((element) => element.productId == cartItem.productId);

      existingCartItem.addQuantity(cartItem.quantity);
    } else {
      _items.add(cartItem);
    }
    notifyListeners();
  }

  void removeSingleItemByProductId(String productId) {
    CartItemProvider item =
        _items.firstWhere((element) => element.productId == productId);
    if (item == null) return;
    if (item.quantity > 1)
      item.quantity = item.quantity - 1;
    else
      _items.removeWhere((element) => element.id == item.id);

    notifyListeners();
  }

  void removeSingleItemById(String id) {
    CartItemProvider item = _items.firstWhere((element) => element.id == id);
    if (item == null) return;
    if (item.quantity > 1)
      item.quantity = item.quantity - 1;
    else
      _items.removeWhere((element) => element.id == item.id);

    notifyListeners();
  }

  void removeFromCartByProductId(String productId) {
    _items.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }

  void removeFromCartById(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
