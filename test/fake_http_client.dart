import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data'; // Required for Uint8List

// This class provides a concrete, predictable mock for network calls.
class FakeHttpClient implements http.Client {
  final String responseBody;
  final int statusCode;

  FakeHttpClient(this.responseBody, this.statusCode);

  // CRITICAL METHOD: Implements the POST call used by GeminiService
  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, body, Encoding? encoding}) async {
    // Returns the preset fake response
    return http.Response(responseBody, statusCode, request: http.Request('POST', url));
  }
  
  // --- FIX 1: Missing method from http.Client interface ---
  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError('Method read not implemented in FakeClient');
  }

  // --- FIX 2: Missing method from http.Client interface ---
  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError('Method readBytes not implemented in FakeClient');
  }

  // --- BOILERPLATE METHODS (Required by http.Client interface) ---
  
  @override
  // ignore: unnecessary_overrides
  void close() {}

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) => throw UnimplementedError('Method GET not implemented in FakeClient');

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) => throw UnimplementedError('Method HEAD not implemented in FakeClient');

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, body, Encoding? encoding}) => throw UnimplementedError('Method PUT not implemented in FakeClient');

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, body, Encoding? encoding}) => throw UnimplementedError('Method PATCH not implemented in FakeClient');

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, body, Encoding? encoding}) => throw UnimplementedError('Method DELETE not implemented in FakeClient');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) => throw UnimplementedError('Method SEND not implemented in FakeClient');
}