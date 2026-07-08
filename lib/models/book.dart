import 'dart:convert';

class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String publishYear;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.publishYear,
  });

  // Converte o JSON da Open Library para o nosso objeto
  factory Book.fromJson(Map<String, dynamic> json) {
    String authorName = 'Autor desconhecido';
    if (json['author_name'] != null && (json['author_name'] as List).isNotEmpty) {
      authorName = json['author_name'][0].toString();
    }
    
    String cover = '';
    if (json['cover_i'] != null) {
      cover = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg';
    }

    return Book(
      id: json['key'] ?? json.hashCode.toString(),
      title: json['title'] ?? 'Sem título',
      author: authorName,
      coverUrl: cover,
      publishYear: json['first_publish_year']?.toString() ?? 'N/A',
    );
  }

  // Converte para salvar no SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'publishYear': publishYear,
    };
  }

  // Recupera do SharedPreferences
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverUrl: map['coverUrl'],
      publishYear: map['publishYear'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Book.fromLocalJson(String source) => Book.fromMap(json.decode(source));
}