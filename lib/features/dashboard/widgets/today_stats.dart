import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTodayStats(int bottles, int orders) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_drink, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Entregado hoy",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "$bottles botellones • $orders pedidos",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
