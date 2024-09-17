import 'package:flutter_app/store/models/models.dart';

List<Inventory> selectAllInventoryItems(AppState state) {
  return state.inventory.allIds.map((id) => state.inventory.byId[id]).toList();
}

List<Inventory> selectInventoryItem(AppState state, String inventoryId) {
  return state.inventory.allIds
      .map((id) => state.inventory.byId[id])
      .where((message) => message.id == inventoryId)
      .toList();
}
