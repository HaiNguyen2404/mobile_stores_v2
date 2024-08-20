import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/models/product_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('Product Repository', () {
    late ProductRepository repository;
    late MockDio mockDio;
    RequestOptions requestOptions = RequestOptions();

    setUp(() {
      mockDio = MockDio();
      repository = ProductRepository(dio: mockDio);
    });

    test('fetchProducts returns products and updates state correctly',
        () async {
      // Arrange
      const mockResponse = '''{
        "content": [
          {
            "id": 1,
            "name": "Iphone 15",
            "price": 1099,
            "quantity": 93,
            "description":
                "Something",
            "manufacturer": "Apple",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/1"
          },
          {
            "id": 2,
            "name": "Samsung Galaxy S23 Ultra 15G",
            "price": 905,
            "quantity": 42,
            "description":
                "Something",
            "manufacturer": "Samsung",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/2"
          }
        ]
      }''';
      when(
        () => mockDio.get(
          any(),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      // Act
      final products = await repository.fetchProducts();

      // Assert
      expect(products.length, 2);
      expect(repository.page, 2);
      expect(repository.hasMore, true);
      verify(() => mockDio.get(any())).called(1);
    });

    test('fetchProducts sets hasMore to false when fewer products are returned',
        () async {
      // Arrange
      const mockResponse = '''{
        "content": [
          {
            "id": 1,
            "name": "Iphone 15",
            "price": 1099,
            "quantity": 93,
            "description":
                "Something",
            "manufacturer": "Apple",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/1"
          }
        ]
      }''';
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      // Act
      final products = await repository.fetchProducts();

      // Assert
      expect(products.length, 1);
      expect(repository.page, 2);
      expect(repository.hasMore, false); // No more products to load
      verify(() => mockDio.get(any())).called(1);
    });

    test('productsRefresh resets the state correctly', () async {
      // Arrange
      repository.page = 5;
      repository.currentProducts = [
        Product(
          id: 1,
          name: 'Product 1',
          price: 100,
          quantity: 1,
          description: '',
          manufacturer: '',
          category: '',
          condition: '',
          image: '',
        ),
      ];
      repository.hasMore = false;

      // Act
      repository.productsRefresh();

      // Assert
      expect(repository.page, 1);
      expect(repository.currentProducts.isEmpty, true);
      expect(repository.hasMore, true);
    });

    test('fetchProducts handles multiple sequential calls', () async {
      const mockResponse1 = '''{
        "content": [
          {
            "id": 1,
            "name": "Iphone 15",
            "price": 1099,
            "quantity": 93,
            "description": "Something",
            "manufacturer": "Apple",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/1"
          },
          {
            "id": 2,
            "name": "Samsung Galaxy S23 Ultra 15G",
            "price": 905,
            "quantity": 42,
            "description": "Something",
            "manufacturer": "Samsung",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/2"
          }
        ]
      }''';
      const mockResponse2 = '''{
        "content": [
          {
            "id": 1,
            "name": "Iphone 15",
            "price": 1099,
            "quantity": 93,
            "description": "Something",
            "manufacturer": "Apple",
            "category": "Phone",
            "condition": "NEW",
            "image": "http://localhost:8080/api/v2/product-images/1"
          }
        ]
      }''';

      when(() => mockDio.get(
          'http://10.0.2.2:8080/api/v2/products?page=1&limit=2')).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse1,
          statusCode: 200,
        ),
      );
      when(() => mockDio.get(
          'http://10.0.2.2:8080/api/v2/products?page=2&limit=2')).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse2,
          statusCode: 200,
        ),
      );

      final products1 = await repository.fetchProducts();
      expect(products1.length, 2);

      final products2 = await repository.fetchProducts();
      expect(products2.length, 3);
      expect(repository.page, 3);
      expect(repository.hasMore, false);
    });
  });

  group('Edge cases', () {
    late ProductRepository repository;
    late MockDio mockDio;
    RequestOptions requestOptions = RequestOptions();

    setUp(() {
      mockDio = MockDio();
      repository = ProductRepository(dio: mockDio);
    });

    test('fetchProducts throws an exception on a non-200 response', () async {
      // Arrange
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: 'Error',
          statusCode: 404,
        ),
      );

      // Act & Assert
      expect(repository.fetchProducts, throwsException);
    });

    test('fetchProducts handles emty product list correctly', () async {
      const mockResponse = "{\"content\": []}";
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      final products = await repository.fetchProducts();

      expect(products.isEmpty, true);
      expect(repository.hasMore, false);
    });

    test('fetchProducts handles emty data gracefully', () async {
      const mockResponse = "{}"; // or missing 'content' key
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      expect(() => repository.fetchProducts(), throwsException);
    });

    test('fetchProducts handles unexpected API structure', () async {
      const mockResponse = '''{"unexpected_key": []}''';
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      expect(() => repository.fetchProducts(), throwsException);
    });

    test('fetchProducts handles API timeouts gracefully', () async {
      when(() => mockDio.get(any())).thenThrow(DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => repository.fetchProducts(), throwsA(isA<DioException>()));
    });

    test('fetchProducts handles no internet connection gracefully', () async {
      when(() => mockDio.get(any())).thenThrow(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => repository.fetchProducts(), throwsA(isA<DioException>()));
    });

    test('fetchProducts handles page overflow gracefully', () async {
      const mockResponse = '''{"content": []}''';
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockResponse,
          statusCode: 200,
        ),
      );

      repository.page = 1000; // Simulate an extremely high page number
      final products = await repository.fetchProducts();

      expect(products.isEmpty, true);
      expect(repository.hasMore, false); // No more products to load
    });
  });
}
