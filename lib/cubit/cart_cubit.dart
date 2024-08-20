import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/cubit/cart_state.dart';
import 'package:mobile_store/models/cart.dart';
import 'package:mobile_store/models/product.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.cartBox, required this.dio}) : super(CartInitial());

  Box cartBox;
  Cart cart = Cart(cartList: [], grandTotal: 0);
  final Dio dio;

  loadCart() {
    try {
      cart.cartList = _castToMap();
      if (cart.cartList != []) {
        cart.grandTotal = cart.calGrandTotal();
        emit(CartItemLoaded(
            cartList: cart.cartList, grandTotal: cart.grandTotal));
      }
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  List<Map<dynamic, dynamic>> _castToMap() {
    return cartBox.values.toList().cast<Map<dynamic, dynamic>>();
  }

  removeItem({int? index}) {
    if (cartBox.isNotEmpty && index == null) {
      cartBox.deleteAll(cartBox.keys);
      cart.cartList.clear();
      cart.grandTotal = cart.calGrandTotal();
    } else if (cartBox.isNotEmpty && index != null) {
      cartBox.delete(index);
      cart.cartList = _castToMap();
      cart.grandTotal = cart.calGrandTotal();
    }
    emit(CartItemLoaded(cartList: cart.cartList, grandTotal: cart.grandTotal));
  }

  checkout() async {
    final body = jsonEncode({
      'total': cart.grandTotal,
      'paymentMethod': 2,
      'orderStatus': 1,
      'details': getOrderMapList(cart.cartList)
    });

    const url = 'http://10.0.2.2:8080/api/v2/orders';

    try {
      final response = await dio.post(url, data: body);

      if (response.statusCode == 201) {
        removeItem();
      } else {
        throw Exception('Check out failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout) {
        emit(CartError(error: 'Connection timeout'));
      } else if (e.type == DioExceptionType.cancel) {
        emit(CartError(error: 'Request cancelled'));
      } else if (e.type == DioExceptionType.badResponse) {
        emit(CartError(error: 'Check out failed: ${e.response?.statusCode}'));
      } else {
        emit(CartError(error: 'Network error: ${e.message}'));
      }
    }
  }

  Map<dynamic, dynamic> convertToOrderMap(Map<dynamic, dynamic> order) {
    Map<dynamic, dynamic> orderMap = {};
    orderMap['productId'] = order['id'];
    orderMap['quantity'] = order['quantity'];
    orderMap['unitPrice'] = order['unitPrice'];

    return orderMap;
  }

  List<Map<dynamic, dynamic>> getOrderMapList(
      List<Map<dynamic, dynamic>> orders) {
    List<Map<dynamic, dynamic>> ordersMapList = [];
    for (Map<dynamic, dynamic> order in orders) {
      ordersMapList.add(convertToOrderMap(order));
    }

    return ordersMapList;
  }

  void writeData(int key, Map<String, dynamic> value) {
    cartBox.put(key, value);
  }

  Map<dynamic, dynamic> getProductMap(int productId) {
    return cartBox.get(productId);
  }

  List<int> getProductId() {
    return cartBox.keys.toList().cast<int>();
  }

  void addOrder(Product product) {
    List<int> productIds = getProductId();
    if (productIds.contains(product.id)) {
      int quantity = getProductMap(product.id)['quantity'];
      quantity++;
      writeData(product.id, {
        'id': product.id,
        'name': product.name,
        'quantity': quantity,
        'unitPrice': product.price,
      });
    } else {
      writeData(
        product.id,
        {
          'id': product.id,
          'name': product.name,
          'quantity': 1,
          'unitPrice': product.price,
        },
      );
    }
  }
}
