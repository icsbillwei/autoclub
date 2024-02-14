import 'dart:convert';
import 'dart:io';

import 'package:gsheets/gsheets.dart';
import 'sheets_api_secret.dart';

import '../models/car.dart';



void getCarList() async {
  const credentials = secret;
  const spreadsheetId = '1hXMin22954xgk3rtsxmEhyC3hbO6IP7kEDydZCp3TUA';

  final gsheets = GSheets(credentials);
  final ss = await gsheets.spreadsheet(spreadsheetId);

  print("getCarList");
  final sheet = ss.worksheetByTitle("carlist");

  final rows = await sheet!.values.map.allRows(fromRow: 3);
  for (var x in rows!) {
    print("> ${x}");
  }
  for (final row in rows!) {
    if (row[1] == null){
      break;
    }
    print("row!");
    int id = int.tryParse(row[1]!)!;
    print(id);
  }
}