import 'package:flutter/material.dart';

class CalculationModel {
  final String title;
  final String subtitle;
  final String weight;
  final String time;
  final String iconName; // Changed from IconData to String
  final Color bgColor;
  final Color iconColor;
  final double weightValue;
  final Map<String, dynamic> details;

  // Getter to convert iconName to IconData when needed
  IconData get icon {
    switch (iconName) {
      case 'circle':
        return Icons.circle;
      case 'square':
        return Icons.square;
      case 'crop_square':
        return Icons.crop_square;
      case 'layers':
        return Icons.layers;
      case 'horizontal_rule':
        return Icons.horizontal_rule;
      case 'view_column':
        return Icons.view_column;
      case 'calculate':
        return Icons.calculate;
      default:
        return Icons.calculate;
    }
  }

  CalculationModel({
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.time,
    required this.iconName, // Now accepts String
    required this.bgColor,
    required this.iconColor,
    required this.weightValue,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'weight': weight,
    'time': time,
    'iconName': iconName,
    'bgColor': bgColor.value,
    'iconColor': iconColor.value,
    'weightValue': weightValue,
    'details': details,
  };

  factory CalculationModel.fromJson(Map<String, dynamic> json) {
    return CalculationModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      weight: json['weight'] ?? '0 kg',
      time: json['time'] ?? '',
      iconName: json['iconName'] ?? 'calculate',
      bgColor: Color(json['bgColor'] ?? 0xFFDBE1FF),
      iconColor: Color(json['iconColor'] ?? 0xFF003EA8),
      weightValue: (json['weightValue'] ?? 0.0).toDouble(),
      details: json['details'] ?? {},
    );
  }
}