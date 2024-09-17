import 'package:flutter/material.dart';

@immutable
class Inventory {
  final String id;
  final String createdTime;
  final Fields fields;

  const Inventory(
      {@required this.id, @required this.createdTime, @required this.fields});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      createdTime: json['createdTime'],
      fields: Fields.fromJson(json['fields']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdTime': createdTime,
        'fields': fields,
      };
}

class Fields {
  DateTime posted;
  String productCode;

  Fields({this.posted, this.productCode});
  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
        posted: DateTime.tryParse(json['Posted']),
        productCode: json['Product Code']);
  }

  Map<String, dynamic> toJson() =>
      {'posted': posted.toIso8601String(), 'productCode': productCode};
}
