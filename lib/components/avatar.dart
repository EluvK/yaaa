import 'package:flutter/material.dart';

Container avatarContainer(BuildContext context, String? avatarUrl,
    {double size = 48, VoidCallback? onTap}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      border: Border.all(color: colorScheme.onSurface, width: 1.5),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: avatarUrl != null
            ? Image.network(avatarUrl,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error))
            : const Icon(Icons.settings),
      ),
    ),
  );
}
