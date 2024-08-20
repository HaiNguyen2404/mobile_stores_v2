import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/cubit/cart_cubit.dart';
import 'package:mobile_store/cubit/cart_state.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'cart_cubit_test.mocks.dart';

void main() {
  group('Cart functions Error', () {
    late CartCubit cartCubit;
    late MockBox mockBox;
    RequestOptions requestOptions = RequestOptions();

    setUp(() {
      mockBox = MockBox();
      cartCubit = CartCubit(cartBox: mockBox, dio: MockDio());
    });

    test('emits CartError when there is an error during cart loading',
        () async {
      when(cartCubit.cartBox.values)
          .thenThrow(Exception('Failed to load cart'));
      cartCubit.loadCart();
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, 'Exception: Failed to load cart');
    });

    test('throws exception when checkout fails', () async {
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenAnswer(
        (_) async => Response(statusCode: 400, requestOptions: requestOptions),
      );
      expect(cartCubit.checkout, throwsException);
    });

    test('handles unexpected data structure in cartBox', () async {
      when(cartCubit.cartBox.values).thenReturn([
        {'unexpected_key': 'value'}
      ]);
      cartCubit.loadCart();
      expect(cartCubit.state, isA<CartError>());
    });

    test('emits CartError when cart contains null data', () {
      when(mockBox.values).thenReturn([null]);

      cartCubit.loadCart();

      expect(cartCubit.state, isA<CartError>());
    });

    test(
        'emits CartItemLoaded with empty cart on removeItem when cart is already empty',
        () {
      when(mockBox.values).thenReturn([]);

      cartCubit.removeItem(index: null);

      verifyNever(mockBox.deleteAll(any));
      expect(cartCubit.state, isA<CartItemLoaded>());
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.isEmpty, true);
      expect(state.grandTotal, 0);
    });

    test('emits CartError when Hive box is unavailable', () {
      // Arrange: Simulate Hive box being unavailable by throwing an exception when accessing the box
      when(mockBox.values).thenThrow(HiveError('Box is unavailable'));

      // Act: Call the loadCart method
      cartCubit.loadCart();

      // Assert: Verify that CartError state is emitted with the correct error message
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, contains('Box is unavailable'));
    });

    test('emits CartError on network error during checkout', () async {
      // Arrange: Simulate a network error (e.g., no internet connection)
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        error: 'Network error',
      ));

      // Act: Call the checkout method
      await cartCubit.checkout();

      // Assert: Verify that CartError state is emitted with the correct error message
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, contains('Network error'));
    });

    test('emits CartError on server error during checkout', () async {
      // Arrange: Simulate a 500 Internal Server Error
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response:
            Response(statusCode: 500, requestOptions: RequestOptions(path: '')),
        type: DioExceptionType.badResponse,
      ));

      // Act: Call the checkout method
      await cartCubit.checkout();

      // Assert: Verify that CartError state is emitted with the correct error message
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, contains('Check out failed: 500'));
    });

    test('emits CartError on timeout error during checkout', () async {
      // Arrange: Simulate a timeout error
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.sendTimeout,
      ));

      // Act: Call the checkout method
      await cartCubit.checkout();

      // Assert: Verify that CartError state is emitted with the correct error message
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, contains('Connection timeout'));
    });

    test('emits CartError on cancellation error during checkout', () async {
      // Arrange: Simulate a cancellation error
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      ));

      // Act: Call the checkout method
      await cartCubit.checkout();

      // Assert: Verify that CartError state is emitted with the correct error message
      expect(cartCubit.state, isA<CartError>());
      final state = cartCubit.state as CartError;
      expect(state.error, contains('Request cancelled'));
    });
  });

  group('Cart Functions', () {
    late CartCubit cartCubit;
    late Box cartBox;
    RequestOptions requestOptions = RequestOptions();

    setUpAll(() async {
      Hive.init("C:\\Users\\ad\\OneDrive\\Desktop\\New folder");
      await Hive.openBox('test_box');
      cartBox = Hive.box('test_box');
    });

    setUp(() {
      cartCubit = CartCubit(cartBox: cartBox, dio: MockDio());
    });

    tearDown(() async {
      await cartBox.clear();
    });

    tearDownAll(() async {
      await cartBox.deleteFromDisk();
    });

    test('The initial state of CartCubit is CartInitial', () {
      expect(cartCubit.state, isA<CartInitial>());
    });

    test('emits CartItemLoaded when cart is loaded successfully', () async {
      // Arrange
      cartBox.add({'id': 1, 'name': 'hai', 'quantity': 2, 'unitPrice': 10});

      // Act & Assert
      cartCubit.loadCart();
      expect(cartCubit.state, isA<CartItemLoaded>());

      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.length, 1);
      expect(state.grandTotal, 20);
    });

    test('removes items from index', () async {
      cartBox.putAll({
        1: {'id': 1, 'name': 'hai', 'quantity': 1, 'unitPrice': 10}
      });
      cartBox.putAll({
        2: {'id': 2, 'name': 'hoang', 'quantity': 2, 'unitPrice': 20}
      });

      cartCubit.loadCart();
      cartCubit.removeItem(index: 1);

      expect(cartCubit.state, isA<CartItemLoaded>());
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.length, 1);
      expect(state.grandTotal, 40);
    });

    test('removes all items', () async {
      cartBox.add({'id': 1, 'name': 'hai', 'quantity': 1, 'unitPrice': 10});
      cartBox.add({'id': 1, 'name': 'hai', 'quantity': 2, 'unitPrice': 5});

      cartCubit.loadCart();
      cartCubit.removeItem();
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.length, 0);
    });

    test('successful checkout removes all items', () async {
      when(cartCubit.dio.post('http://10.0.2.2:8080/api/v2/orders',
              data: anyNamed('data')))
          .thenAnswer((_) async =>
              Response(requestOptions: requestOptions, statusCode: 201));

      await cartCubit.checkout();
      expect(cartBox.length, 0);
      verify(cartCubit.checkout()).call(1);
    });

    test('adds new product to cart', () async {
      final product = Product(
        id: 1,
        name: 'name',
        price: 2,
        quantity: 1,
        description: 'description',
        manufacturer: 'manufacturer',
        category: 'category',
        condition: 'condition',
        image: 'image',
      );
      cartCubit.addOrder(product);
      cartCubit.loadCart();
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.length, 1);
      expect(state.cartList, [
        {'id': 1, 'name': 'name', 'quantity': 1, 'unitPrice': 2},
      ]);
    });

    test('updates quantity when product already exists in cart', () async {
      final product = Product(
        id: 1,
        name: 'name',
        price: 2,
        quantity: 1,
        description: 'description',
        manufacturer: 'manufacturer',
        category: 'category',
        condition: 'condition',
        image: 'image',
      );
      cartCubit.addOrder(product);
      cartCubit.addOrder(product);
      cartCubit.loadCart();
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.length, 1);
      expect(state.cartList, [
        {'id': 1, 'name': 'name', 'quantity': 2, 'unitPrice': 2},
      ]);
    });

    test('emits CartItemLoaded with empty cart when no items are present',
        () async {
      cartCubit.loadCart();
      expect(cartCubit.state, isA<CartItemLoaded>());
      final state = cartCubit.state as CartItemLoaded;
      expect(state.cartList.isEmpty, true);
      expect(state.grandTotal, 0);
    });
  });
}
