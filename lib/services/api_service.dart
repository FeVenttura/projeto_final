import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://openlibrary.org/search.json';

  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&limit=15');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List docs = data['docs'];
        return docs.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Erro no servidor. Código: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tempo limite excedido. Verifique sua conexão.');
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } catch (e) {
      throw Exception('Erro ao buscar livros: $e');
    }
  }

  Future<String> getBookDescription(String id) async {
    final url = Uri.parse('https://openlibrary.org$id.json');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['description'] != null) {
          if (data['description'] is String) {
            return data['description'];
          } else if (data['description'] is Map && data['description']['value'] != null) {
            return data['description']['value'];
          }
        }
        return 'Nenhum resumo cadastrado para esta obra na Open Library.';
      }
      return 'Não foi possível carregar os detalhes adicionais.';
    } catch (e) {
      return 'Não foi possível carregar o resumo no momento.';
    }
  }
}