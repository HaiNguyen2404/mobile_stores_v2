import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/models/product_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRepository productRepository;
  MockDio mockDio = MockDio();
  RequestOptions requestOptions = RequestOptions();
  int page = 1;
  int limit = 2;
  group('ProductRepository response - ', () {
    setUp(() {
      productRepository = ProductRepository(dio: mockDio);
    });
    test(
      'Given ProductRepository when fetchProducts is called and status code is 200 then a Product List should be returned',
      () async {
        when(
          () => mockDio.get(
              'http://192.168.0.4:8080/api/v2/products?page=$page&limit=$limit'),
        ).thenAnswer((_) async {
          return Response(
            requestOptions: requestOptions,
            data: '''{
              "content": [
                {
                  "id": 1,
                  "name": "Iphone 15",
                  "price": 1099,
                  "quantity": 99,
                  "description":
                      "The innovative new design features back glass that has colour infused throughout the material. A custom dual-ion exchange process for the glass and an aerospace-grade aluminium enclosure help make iPhone 15 incredibly durable.",
                  "manufacturer": "Apple",
                  "category": "Phone",
                  "condition": "NEW",
                  "image": "http://localhost:8080/api/v2/product-images/1"
                }
              ]
            }''',
            statusCode: 200,
          );
        });
        // Act
        List<Product> products = await productRepository.fetchProducts();
        // Assert
        expect(products, isA<List<Product>>());
      },
    );

    test(
      'Given ProductRepository when fetchProducts is called and status code is not 200 then throw an exception',
      () async {
        when(
          () => mockDio.get(
              'http://192.168.0.4:8080/api/v2/products?page=$page&limit=$limit'),
        ).thenAnswer((_) async {
          return Response(
            requestOptions: requestOptions,
            data: '{}',
            statusCode: 404,
          );
        });

        expect(productRepository.fetchProducts(), throwsException);
      },
    );
  });

  group(
      'Given ProductRepository when fetchProducts is called and variables should be as mentioned below',
      () {
    setUpAll(() {
      productRepository = ProductRepository(
        dio: Dio(
          BaseOptions(
            responseType: ResponseType.plain,
          ),
        ),
      );
    });
    test(
      'Initial of page',
      () {
        expect(productRepository.page, 1);
      },
    );
    test(
      'hasMore variable',
      () {
        expect(productRepository.hasMore, true);
      },
    );
    test(
      'page is now 2',
      () async {
        await productRepository.fetchProducts();
        expect(productRepository.page, 2);
      },
    );
    test(
      'hasMore is now true',
      () async {
        await productRepository.fetchProducts();
        expect(productRepository.hasMore, true);
      },
    );
    test(
      'hasMore is now false',
      () async {
        await productRepository.fetchProducts();
        expect(productRepository.hasMore, false);
      },
    );
    test(
      'Products count should be 4',
      () {
        expect(productRepository.currentProducts.length, 4);
      },
    );
  });
}
