
import 'package:flutter/material.dart';

class Inventory {
  final String id;
  final String createdTime;
  final Map<String, dynamic> fields;

  Inventory({
    @required this.id,
    @required this.createdTime,
    @required this.fields
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      createdTime: json['createdTime'],
      fields: {
        'Posted': DateTime.tryParse(json['fields']['Posted']),
        'Product Code': json['fields']['Product Code'] ?? ''
      }
    );
  }
}