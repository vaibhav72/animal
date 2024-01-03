import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl; //  base URL for the API

  HttpClient(this.baseUrl);

  // Simulated HTTP methods
  Future<http.Response> get(String endpoint) async {
    // Simulate a GET request
    final uri = Uri.parse('$baseUrl$endpoint');
    return await http.get(uri);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    // Simulate a POST request
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(uri, body: json.encode(body));
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    // Simulate a PUT request
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(uri,
        body: json.encode(body), headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    // Simulate a DELETE request
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(uri);
    return response;
  }
}
