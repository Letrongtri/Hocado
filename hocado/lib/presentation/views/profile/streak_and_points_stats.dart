import 'dart:ui';
import 'package:flutter/material.dart';

class StreakAndPointsStats extends StatelessWidget {
  const StreakAndPointsStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            value: "0",
            label: "Vệt",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.monetization_on, // Thay bằng icon chữ K
            iconColor: Colors.amber,
            value: "1420",
            label: "đồng xu",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
