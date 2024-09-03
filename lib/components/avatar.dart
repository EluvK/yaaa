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
            ? Image.network(avatarUrl,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.black87))
            : const Icon(Icons.question_answer_rounded, color: Colors.black87),
      ),
    ),
  );
}
