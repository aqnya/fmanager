import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.children,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: colorScheme.secondary)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );

    return Card(
      color: colorScheme.onsecondary,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: cardContent,
            )
          : cardContent,
    );
  }
}