import 'package:flutter/material.dart';

class ProfileModel {
  static const List<Map<String, dynamic>> category = [
    {
      'title': 'Become a partner',
      'icon': Icon(
        Icons.handshake_outlined,
        color: Colors.green,
      )
    },
    {
      'title': 'Favorite',
      'icon': Icon(
        Icons.favorite_outline_sharp,
        color: Colors.red,
      )
    },
    {
      'title': 'My rating',
      'icon': Icon(
        Icons.star_border,
        color: Colors.amber,
      )
    },
    {
      'title': 'Follwings',
      'icon': Icon(
        Icons.local_convenience_store_outlined,
        color: Colors.blue,
      )
    },
  ];
}
