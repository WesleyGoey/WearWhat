import 'package:flutter/material.dart';


import '../data/models.dart';
import 'clothing_art.dart';


/// Foto baju dari Supabase Storage. Kalau baju belum punya foto, atau fotonya
/// gagal dimuat, tampilkan ilustrasi ClothingArt seperti sebelumnya.
class ItemImage extends StatelessWidget {
  const ItemImage({super.key, required this.item, required this.size});


  final ClothingItem item;
  final double size;


  @override
  Widget build(BuildContext context) {
    final art = ClothingArt(
      category: item.category,
      color: item.color,
      size: size,
    );
    final url = item.photoUrl;
    if (url == null) return art;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => art,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : SizedBox.square(
                dimension: size,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
      ),
    );
  }
}
