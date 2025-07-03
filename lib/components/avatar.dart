import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Container avatarContainer(BuildContext context, String? avatarUrl,
    {double size = 48, VoidCallback? onTap, Color color = Colors.white}) {
  final colorScheme = Theme.of(context).colorScheme;
  color = color.withOpacity(0.9);
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      border: Border.all(color: colorScheme.onSurface, width: 1.5),
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.black87),
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 300))
            : const Icon(Icons.question_answer_rounded, color: Colors.black87),
      ),
    ),
  );
}
