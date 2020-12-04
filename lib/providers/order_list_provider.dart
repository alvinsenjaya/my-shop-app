import 'package:flutter/foundation.dart';
import 'package:my_shop_app/providers/cart_list_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItemProvider> cart;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.date,
    @required this.amount,
    @required this.cart,
  });
}

class OrderListProvider with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(OrderItem orderItem) {
    if (orderItem.amount > 0 || orderItem.cart.length > 0) {
      _items.insert(0, orderItem);
      notifyListeners();
    }
  }
}
