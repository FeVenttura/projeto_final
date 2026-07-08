import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();
  
  bool _isFavorite = false;
  String _description = '';
  bool _isLoadingDescription = true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _fetchBookDetails();
  }

  void _checkFavorite() async {
    final isFav = await _storageService.isFavorite(widget.book.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _fetchBookDetails() async {
    final description = await _apiService.getBookDescription(widget.book.id);
    if (mounted) {
      setState(() {
        _description = description;
        _isLoadingDescription = false;
      });
    }
  }

  void _toggleFavorite() async {
    await _storageService.toggleFavorite(widget.book);
    _checkFavorite();
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Removido dos favoritos.' : 'Adicionado aos favoritos!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Livro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.book.coverUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.book.coverUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.menu_book, size: 100, color: Colors.grey),
                ),
              )
            else
              const Icon(Icons.menu_book, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              widget.book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Autor: ${widget.book.author}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Primeira Publicação: ${widget.book.publishYear}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sinopse / Sobre a Obra',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _isLoadingDescription
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    _description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleFavorite,
        icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
        label: Text(_isFavorite ? 'Remover Favorito' : 'Favoritar'),
        backgroundColor: _isFavorite ? Colors.red.shade100 : null,
        foregroundColor: _isFavorite ? Colors.red : null,
      ),
    );
  }
}