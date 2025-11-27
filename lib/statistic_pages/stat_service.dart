import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'stat_model.dart';

class StatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<StatData>> getStatsForMonth({
    required String uid,
    required DateTime month,
  }) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .where('created', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('created', isLessThan: Timestamp.fromDate(end))
        .get();

    final Map<String, int> sums = {};

    for (final doc in snap.docs) {
      final data = doc.data();
      if (data['type'] != 'expense') continue;

      final String title = (data['title'] ?? 'Lainnya').toString();
      final dynamic rawAmount = data['amount'];

      final int amount = rawAmount is int
          ? rawAmount
          : int.tryParse(rawAmount.toString()) ?? 0;

      if (amount <= 0) continue;

      sums[title] = (sums[title] ?? 0) + amount;
    }

    final colors = <Color>[
      const Color(0xFFE91E63),
      const Color(0xFF3F51B5),
      const Color(0xFFFF9800),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFF009688),
    ];

    final icons = <IconData>[
      Icons.home_outlined,
      Icons.fastfood_outlined,
      Icons.shopping_bag_outlined,
      Icons.directions_car_outlined,
      Icons.movie_outlined,
      Icons.more_horiz,
    ];

    int i = 0;
    final list = sums.entries.map<StatData>((e) {
      final idx = i++;
      return StatData(
        e.key,
        e.value.toDouble(), // ✅ FIXED
        colors[idx % colors.length],
        icons[idx % icons.length],
      );
    }).toList();

    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }
}
