import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/store/actions/actions.dart';
import 'package:flutter_app/store/models/models.dart';
import 'package:flutter_app/store/selectors/selectors.dart';
import 'package:flutter_app/widgets/alert_dialog.dart';
import 'package:flutter_app/widgets/loading_indicator.dart';
import 'package:flutter_app/widgets/qr_code_scanner.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class InventoryListScreen extends StatefulWidget {
  final RouteObserver routeObserver;

  InventoryListScreen(this.routeObserver);

  @override
  State<StatefulWidget> createState() => InventoryListState();
}

class InventoryListState extends State<InventoryListScreen> with RouteAware {
  List<Inventory> inventory = [];

  void _fetchInventory(Store<AppState> store) async {
    Completer completer = new Completer();
    store.dispatch(fetchInventory(completer: completer));

    try {
      await completer.future;
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) => _fetchInventory(store),
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          appBar: AppBar(title: Text('Inventory')),
          body: RefreshIndicator(
            child: !vm.fetching && !vm.sending
                ? ListView(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0))),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Product Code'),
                              ),
                              Text('Scan Date'),
                            ],
                          )),
                      ...vm.inventoryList.map((Inventory item) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0))),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(item.fields.productCode != null
                                    ? item.fields.productCode
                                    : "null"),
                              ),
                              Text(DateFormat.yMd()
                                  .add_jm()
                                  .format(item.fields.posted)),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  )
                : Center(
                    child: LoadingIndicator(),
                  ),
            onRefresh: () => _onRefresh(vm),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                _onScanCode(vm);
              },
              tooltip: 'Scan code',
              child: Icon(Icons.add)),
        );
      },
    );
  }

  Future<dynamic> _onRefresh(_ViewModel vm) async {
    Completer completer = Completer();

    vm.onRefresh(
      completer: completer,
    );

    try {
      return await completer.future;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> _onScanCode(_ViewModel vm) async {
    Completer completer = Completer();
    String bnr = await showQrCodeScanner(context);
    print(bnr);

    if (bnr == 'The user did not grant the camera permission!')
      showSimpleDialog(
          context, 'Please grant permission for using the camera.');
    else if (bnr != null) {
      vm.onScanCode(
        code: bnr,
        completer: completer,
      );
    } else {
      showSimpleDialog(context, 'Scanning qr code failed');
    }

    try {
      return await completer.future;
    } catch (e) {
      print(e);
    }
  }
}

class _ViewModel {
  final List<Inventory> inventoryList;
  final bool sending;
  final bool fetching;
  final Function({Completer completer}) onRefresh;
  final Function({String code, Completer completer}) onScanCode;

  _ViewModel(
      {@required this.inventoryList,
      @required this.onRefresh,
      @required this.sending,
      @required this.fetching,
      @required this.onScanCode});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        inventoryList: selectAllInventoryItems(store.state),
        sending: store.state.inventory.sending,
        fetching: store.state.inventory.fetching,
        onRefresh: ({
          Completer completer,
        }) {
          store.dispatch(fetchInventory(completer: completer));
        },
        onScanCode: ({String code, Completer completer}) {
          store.dispatch(sendInventory(code: code, completer: completer));
        });
  }
}
