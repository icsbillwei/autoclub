import 'package:autoclub_frontend/models/car.dart';
import 'package:flutter/material.dart';

class UserData {
  String username;
  TimeOfDay time;
  int currentDay;
  int money;
  Car? currentCar;
  List<Car> userCarList;
  int currUserCarId;

  UserData({
    required this.username,
    required this.time,
    required this.currentDay,
    required this.money,
    this.currentCar,
    required this.userCarList,
    required this.currUserCarId,
  });

  // TODO convert car type to binary jsonb
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'time': '${time.hour}:${time.minute}',
      'currentDay': currentDay,
      'money': money,
      'currentCar': currentCar?.toMap(),
      'userCarList': userCarList.map((car) => car.toMap()).toList(),
      'currUserCarId': currUserCarId,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    // TODO probably needs modifying to suit DB
    var userCarList = null;
    if (map['userCarList'] != null) {
      userCarList =
          List<Car>.from(map['userCarList']?.map((x) => Car.fromMap(x)));
    }

    return UserData(
      username: map['username'],
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      currentDay: map['currentDay'],
      money: map['money'],
      currentCar:
          map['currentCar'] != null ? Car.fromMap(map['currentCar']) : null,
      userCarList: userCarList,
      currUserCarId: map['currUserCarId'],
    );
  }
}
