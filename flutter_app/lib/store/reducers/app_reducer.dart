import 'package:flutter_app/store/models/models.dart';
import 'package:flutter_app/store/reducers/inventory_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    inventory: inventoryReducer(state.inventory, action),
  );
}