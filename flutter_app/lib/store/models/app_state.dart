import 'dart:convert';

import 'package:flutter_app/store/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final InventoryState inventory;

  const AppState({
    @required this.inventory,
  });

  Map<String, dynamic> toJson() => {
        'inventory': inventory,
      };

  @override
  String toString() {
    return 'InventoryState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
