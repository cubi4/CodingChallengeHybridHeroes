import 'package:flutter_app/store/actions/actions.dart';
import 'package:flutter_app/store/models/models.dart';
import 'package:redux/redux.dart';

final inventoryReducer = combineReducers<InventoryState>([
  TypedReducer<InventoryState, FetchInventorySuccess>(
      _setInventoryActionReducer),
  TypedReducer<InventoryState, FetchInventory>(_setFetchingReducer),
  TypedReducer<InventoryState, FetchInventoryError>(_setFetchingErrorReducer),
  TypedReducer<InventoryState, SendInventory>(_setSendingReducer),
  TypedReducer<InventoryState, SendInventoryError>(_setSendingErrorReducer)
]);

InventoryState _setInventoryActionReducer(
    InventoryState state, FetchInventorySuccess action) {
  List<Inventory> inventoryList = action.inventory;
  final allIds = inventoryList.map((item) => item.id).toList();
  final Map<String, Inventory> byId = {};
  inventoryList.forEach((inventory) => byId[inventory.id] = inventory);

  return InventoryState(
      byId: byId, allIds: allIds, fetching: false, sending: false);
}

InventoryState _setFetchingReducer(
    InventoryState state, FetchInventory action) {
  return state.copyWith(fetching: action.fetching);
}

InventoryState _setFetchingErrorReducer(
    InventoryState state, FetchInventoryError action) {
  return state.copyWith(fetching: action.fetching);
}

InventoryState _setSendingReducer(InventoryState state, SendInventory action) {
  return state.copyWith(sending: action.sending);
}

InventoryState _setSendingErrorReducer(
    InventoryState state, SendInventoryError action) {
  return state.copyWith(sending: action.sending);
}
