import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/store/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class FetchInventory {
  final bool fetching;

  FetchInventory(this.fetching);
}

class FetchInventorySuccess {
  final List<Inventory> inventory;

  FetchInventorySuccess(this.inventory);
}

class FetchInventoryError {
  final bool fetching;

  FetchInventoryError(this.fetching);
}

class SendInventory {
  final bool sending;

  SendInventory(this.sending);
}

class SendInventorySuccess {
  final bool sending;

  SendInventorySuccess(this.sending);
}

class SendInventoryError {
  final bool sending;

  SendInventoryError(this.sending);
}

ThunkAction<AppState> fetchInventory({@required Completer completer}) {
  return (Store<AppState> store) async {
    store.dispatch(
      FetchInventory(true),
    );

    try {
      var url =
          "https://api.airtable.com/v0/appJkRh9E7qNlXOav/Home?offset=0&maxRecords=100&view=Grid%20view";
      var response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "Bearer key0k536xA7VpPtEd"},
      );
      Map<String, dynamic> result = json.decode(response.body);

      List<Inventory> inventoryList =
          List.from(result['records']).map((record) {
        return Inventory.fromJson(record);
      }).toList();

      store.dispatch(
        FetchInventorySuccess(inventoryList),
      );
      completer.complete();
    } catch (error) {
      store.dispatch(
        FetchInventoryError(false),
      );
      completer.complete(error);
    }
  };
}

ThunkAction<AppState> sendInventory(
    {@required code, @required Completer completer}) {
  return (Store<AppState> store) async {
    store.dispatch(SendInventory(true));
    try {
      var productCode = {};
      productCode["Product Code"] = code;
      var fields = {};
      fields["fields"] = productCode;
      var body = jsonEncode(fields);
      print('post body: $fields');
      var url =
          "https://api.airtable.com/v0/appJkRh9E7qNlXOav/Home?maxRecords=100&view=Grid%20view";
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer key0k536xA7VpPtEd",
            HttpHeaders.contentTypeHeader: "application/json"
          },
          body: body);

      store.dispatch(SendInventorySuccess(true));

      Completer fetchNewInventoryCompleter = new Completer();

      store.dispatch(fetchInventory(completer: fetchNewInventoryCompleter));

      completer.complete();
    } catch (error) {
      SendInventoryError(false);
      completer.complete(error);
    }
  };
}
