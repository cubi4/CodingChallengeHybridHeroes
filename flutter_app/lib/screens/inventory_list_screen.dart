import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InventoryListScreen extends StatefulWidget {
  final RouteObserver routeObserver;

  InventoryListScreen(this.routeObserver);

  @override
  State<StatefulWidget> createState() => InventoryListState();
}

class InventoryListState extends State<InventoryListScreen> with RouteAware {
  List<Inventory> inventory = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
    fetchInventory();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory')
      ),
      body: ListView(children: <Widget>[
        Container(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0))),
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Product Code'),
                ),
                Text('Scan Date'),
              ],
            )),
        ...inventory.map((Inventory item) {
          return Container(
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 0))),
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(item.fields['Product Code']),
                  ),
                  Text(DateFormat.yMd().add_jm().format(item.fields['Posted'])),
                ],
              ));
        }).toList(),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            openScanner();
          },
          tooltip: 'Scan code',
          child: Icon(Icons.add)),
    );
  }

  void fetchInventory() async {
    var url =
        "https://api.airtable.com/v0/appJkRh9E7qNlXOav/Home?offset=0&maxRecords=100&view=Grid%20view";
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: "Bearer key0k536xA7VpPtEd"},
    );
    var result = json.decode(response.body);

    setState(() {
      inventory = List.from(result['records']).map((record) {
        return Inventory.fromJson(record);
      }).toList();
    });
  }

  void openScanner() {
    // scanner logic
  }
}
