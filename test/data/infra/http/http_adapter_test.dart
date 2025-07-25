import 'package:curso_avancado/data/data.dart';
import 'package:curso_avancado/infra/infra.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late final ClientSpy client;
  late final HttpAdapter sut;
  late final String url;
  setUpAll(() {
    registerFallbackValue(Uri());
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group(
    'shared',
    () {
      test(
        'Shloud throw ServerError if invalid method is provided',
        () {
          when(() => client.post(
                any(),
                headers: any(named: 'headers'),
                body: any(named: 'body'),
              )).thenThrow(Exception());

          final future = sut.request(url: url, method: 'invalid_method');
          expect(future, throwsA(HttpError.serverError));
        },
      );
    },
  );

  group('Post', () {
    makeRequest(String? body) {
      return when(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: body,
          ));
    }

    mockResponse(
        {String? body,
        required int statusCode,
        String bodyResponse = '{"any_key":"any_value"}'}) {
      makeRequest(body).thenAnswer(
        (invocation) async => Response(bodyResponse, statusCode),
      );
    }

    setUp(() {
      mockResponse(body: null, statusCode: 200);
    });
    test('Should call post with correct values', () async {
      mockResponse(body: '{"any_key":"any_value"}', statusCode: 200);

      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(
        () => client.post(Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}'),
      ).called(1);
    });
    test('Should call post without body', () async {
      when(() => client.post(
            any(),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
          )).thenAnswer(
        (invocation) async => Response('', 200),
      );

      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        () => client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
        ),
      ).called(1);
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(
        url: url,
        method: 'post',
      );
      expect(response, {'any_key': 'any_value'});
    });
    test('Should return data if post returns 200 with no data', () async {
      mockResponse(statusCode: 200, bodyResponse: '');
      final response = await sut.request(
        url: url,
        method: 'post',
      );
      expect(response, null);
    });
    test('Should return data if post returns 204', () async {
      mockResponse(statusCode: 204);

      final response = await sut.request(
        url: url,
        method: 'post',
      );
      expect(response, null);
    });
    test('Should return BadRequest if post return 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.badRequest));
    });
    test('Should return BadRequest if post return 400', () async {
      mockResponse(statusCode: 400, bodyResponse: '');

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return ServerError if post return 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.serverError));
    });
    test('Should return UnathorizedError if post return 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.unauthorized));
    });
    test('Should return ForbiddenError if post return 403', () async {
      mockResponse(statusCode: 403);

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.forbidden));
    });
    test('Should return NotfoundError if post return 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.request(
        url: url,
        method: 'post',
      );
      expect(future, throwsA(HttpError.notFound));
    });

    test(
      'Should return ServerError if post throws',
      () {
        when(() => client.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            )).thenThrow(Exception());

        final future = sut.request(url: url, method: 'post');
        expect(future, throwsA(HttpError.serverError));
      },
    );
  });
}
