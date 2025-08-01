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
  
  
Color adjustLightness(Color color, double amount) {
  assert(amount >= -1.0 && amount <= 1.0);
  final hsl = HSLColor.fromColor(color);
  final adjusted = hsl.withLightness(
    (hsl.lightness + amount).clamp(0.0, 1.0),
  );
  return adjusted.toColor();
}

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
                  ?.copyWith(color: colorScheme.onSurface)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );

    return Card(
      color: adjustLightness(colorScheme.surface,0.1),
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


Widget WarningCard(BuildContext context, {VoidCallback? onTap}) {
  final colorScheme = Theme.of(context).colorScheme;

  final content = Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Icon(
          Icons.warning_amber,
          color: colorScheme.onErrorContainer,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '未安装',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '点击安装',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return Card(
    color: colorScheme.errorContainer,
    margin: const EdgeInsets.only(bottom: 16.0),
    child: onTap != null
        ? InkWell(
            onTap: onTap,
            child: content,
          )
        : content,
  );
}