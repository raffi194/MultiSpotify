import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FavoriteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.favorite_border, color: Colors.white),
    );
  }
}
