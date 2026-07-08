import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final String tagPrefix;

  const BookDetailScreen({super.key, required this.book, this.tagPrefix = 'search_'});

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
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_isFavorite ? Icons.favorite_border : Icons.favorite, color: Colors.white),
            const SizedBox(width: 12),
            Text(_isFavorite ? 'Removido dos favoritos' : 'Adicionado aos favoritos!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0, 
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, right: 16, bottom: 16),
              title: Text(
                widget.book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, top: 16.0), 
                    child: Hero(
                      tag: '${widget.tagPrefix}${widget.book.id}',
                      child: widget.book.coverUrl.isNotEmpty
                          ? Image.network(
                              widget.book.coverUrl,
                              fit: BoxFit.contain, 
                              errorBuilder: (c, e, s) => const Icon(Icons.menu_book, size: 100, color: Colors.grey),
                            )
                          : const Icon(Icons.menu_book, size: 100, color: Colors.grey),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0], 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.book.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Por ${widget.book.author}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Publicado em: ${widget.book.publishYear ?? 'N/D'}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Sinopse / Sobre a Obra',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _isLoadingDescription
                        ? const Padding(padding: EdgeInsets.all(32.0), child: Center(child: CircularProgressIndicator()))
                        : Text(
                            _description.isNotEmpty ? _description : 'Sinopse não disponível para esta obra.',
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey.shade800),
                          ),
                  ),
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleFavorite,
        elevation: 4,
        icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
        label: Text(_isFavorite ? 'Salvo' : 'Favoritar'),
        backgroundColor: _isFavorite ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: _isFavorite ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}