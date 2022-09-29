import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amoun;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amoun, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [...orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        DateTime.now().toString(),
        total,
        cartProducts,
        DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
