import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.landscape_outlined,
            color: Colors.grey,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        // Welcome Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello,', style: theme.textTheme.bodyMedium),
            Text(
              'Trọng trí',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Notification Bell
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
          iconSize: 28,
        ),
      ],
    );
  }
}
