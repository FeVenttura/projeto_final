import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_books';

  // Recupera a lista de favoritos
  Future<List<Book>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);

    if (favoritesJson == null) return [];

    return favoritesJson.map((jsonStr) => Book.fromLocalJson(jsonStr)).toList();
  }

  // Adiciona ou remove dos favoritos
  Future<void> toggleFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    List<Book> favorites = await getFavorites();
    
    final isFav = favorites.any((b) => b.id == book.id);

    if (isFav) {
      favorites.removeWhere((b) => b.id == book.id);
    } else {
      favorites.add(book);
    }

    final List<String> updatedJsonList = favorites.map((b) => b.toJson()).toList();
    await prefs.setStringList(_favoritesKey, updatedJsonList);
  }

  // Verifica se um livro específico é favorito
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((b) => b.id == id);
  }
}