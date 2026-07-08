import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/storage_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  List<Book> _favoriteBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      _favoriteBooks = favorites;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
              ? const Center(child: Text('Você ainda não favoritou nenhum livro.'))
              : ListView.builder(
                  itemCount: _favoriteBooks.length,
                  itemBuilder: (context, index) {
                    final book = _favoriteBooks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: book.coverUrl.isNotEmpty
                            ? Image.network(book.coverUrl, width: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.book, size: 50))
                            : const Icon(Icons.book, size: 50),
                        title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(book.author),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _storageService.toggleFavorite(book);
                            _loadFavorites(); // Atualiza a lista após remover
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
                          ).then((_) => _loadFavorites());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}