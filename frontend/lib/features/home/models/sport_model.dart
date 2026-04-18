import 'package:flutter/material.dart';

class SportModel {
  const SportModel({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final IconData icon;

  static const List<SportModel> defaults = [
    SportModel(id: 'all', label: 'All', icon: Icons.apps_rounded),
    SportModel(
      id: 'football',
      label: 'Football',
      icon: Icons.sports_soccer_rounded,
    ),
    SportModel(id: 'padel', label: 'Padel', icon: Icons.sports_tennis_rounded),
    SportModel(
      id: 'tennis',
      label: 'Tennis',
      icon: Icons.sports_tennis_rounded,
    ),
    SportModel(
      id: 'basketball',
      label: 'Basketball',
      icon: Icons.sports_basketball_rounded,
    ),
    SportModel(
      id: 'volleyball',
      label: 'Volleyball',
      icon: Icons.sports_volleyball_rounded,
    ),
  ];
}
