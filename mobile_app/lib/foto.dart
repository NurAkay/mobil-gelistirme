import 'package:flutter/material.dart';

// Dairesel profil fotoğrafı (internetten çeker, yüklenemezse ikon gösterir)
class Foto extends StatelessWidget {
  final String url;
  final double size;
  const Foto(this.url, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Icon(Icons.account_circle, size: size, color: Colors.grey),
      ),
    );
  }
}
