import 'package:flutter_app/store/models/models.dart';
import 'package:meta/meta.dart';

@Immutable()
class InventoryState {
  final List<String> allIds;
  final Map<String, Inventory> byId;
  final bool fetching;
  final bool sending;

  const InventoryState(
      {this.allIds = const <String>[],
      this.byId = const <String, Inventory>{},
      this.fetching,
      this.sending});

  InventoryState.fromJson(Map<String, dynamic> json)
      : allIds = json != null ? json['allIds'] : null,
        byId = json != null ? json['byId'] : null,
        fetching = json != null ? json['fetching'] : false,
        sending = json != null ? json['sending'] : false;

  InventoryState copyWith(
      {List<String> allIds,
      Map<String, Inventory> byId,
      bool fetching,
      bool sending}) {
    return InventoryState(
      allIds: allIds ?? this.allIds,
      byId: byId ?? this.byId,
      fetching: fetching ?? this.fetching,
      sending: sending ?? this.sending,
    );
  }

  Map<String, dynamic> toJson() => {
        'byId': byId,
        'allIds': allIds,
        'fetching': fetching,
        'sending': sending
      };
}
