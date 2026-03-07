import 'dart:ui';

import 'package:flutter/material.dart';

Color getOrderColor(DateTime createdAt) {
  final minutes = DateTime.now().difference(createdAt).inMinutes;
  if (minutes < 15) {
    return Colors.green.shade200;
  } else if (minutes < 20) {
    return Colors.yellow.shade200;
  } else if (minutes < 30) {
    return Colors.orange.shade200;
  } else {
    return Colors.red.shade300;
  }
}