import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:gsheets/gsheets.dart';
import 'sheets_api_secret.dart';

import '../models/car.dart';

Future<List<CarModel>> getCarList() async {
  const credentials = secret;
  const spreadsheetId = '1hXMin22954xgk3rtsxmEhyC3hbO6IP7kEDydZCp3TUA';

  final gsheets = GSheets(credentials);
  final ss = await gsheets.spreadsheet(spreadsheetId);

  print("!! getCarList");
  List<CarModel> carList = [];
  final sheet = ss.worksheetByTitle("carlist");

  final rows = await sheet!.values.map.allRows(fromRow: 1);
  /*
  debug u
  for (var x in rows!) {
    print("> ${x}");
  }
   */
  for (final row in rows!) {
    if (row["id"] == "" || row["id"] == null) {
      break;
    }

    int id = int.tryParse(row["id"]!)!;
    String brandName = row["brandName"]!;
    String name = row["name"]!;
    int year = int.tryParse(row["year"]!)!;
    int newPrice = int.tryParse(row["newPrice"]!)!;
    CarType type = CarType.values[int.tryParse(row["type"]!)!];
    List<String> tagStringList = row["tags"]!.split(",");
    List<CarTag> tags = tagStringList.map((s) {
      return CarTag.values[int.tryParse(s)!];
    }).toList();
    Country country = Country.values[int.tryParse(row["country"]!)!];
    DrivetrainType drivetrainType =
        DrivetrainType.values[int.tryParse(row["drivetrainType"]!)!];
    EngineType engineType =
        EngineType.values[int.tryParse(row["engineType"]!)!];
    double displacement = double.tryParse(row["displacement"]!)!;
    EngineAspiration aspirationType =
        EngineAspiration.values[int.tryParse(row["aspirationType"]!)!];
    CargoSpace space = CargoSpace.values[int.tryParse(row["space"]!)!];
    int power = int.tryParse(row["power"]!)!;
    int weight = int.tryParse(row["weight"]!)!;
    int seatCount = int.tryParse(row["seatCount"]!)!;
    double accel = double.tryParse(row["accel"]!)!;
    double qmile = double.tryParse(row["qmile"]!)!;
    int vmax = int.tryParse(row["vmax"]!)!;
    double handling0 = double.tryParse(row["handling0"]!)!;
    double handling1 = double.tryParse(row["handling1"]!)!;
    double braking = double.tryParse(row["braking"]!)!;
    double depCurve = double.tryParse(row["depCurve"]!)!;
    int maxMileage = int.tryParse(row["maxMileage"]!)!;
    int minMileage = int.tryParse(row["minMileage"]!)!;
    String imgLinks = row["imageLinks"]!;
    String designer = row["designer"]!;

    carList.add(CarModel(
        id: id,
        brandName: brandName,
        name: name,
        year: year,
        newPrice: newPrice,
        type: type,
        tags: tags,
        country: country,
        drivetrainType: drivetrainType,
        engineType: engineType,
        displacement: displacement,
        aspirationType: aspirationType,
        space: space,
        power: power,
        weight: weight,
        seatCount: seatCount,
        accel: accel,
        qmile: qmile,
        vmax: vmax,
        handling0: handling0,
        handling1: handling1,
        braking: braking,
        depCurve: depCurve,
        maxMileage: maxMileage,
        minMileage: minMileage,
        imgLinks: imgLinks,
        designer: designer));
  }

  return carList;
}
