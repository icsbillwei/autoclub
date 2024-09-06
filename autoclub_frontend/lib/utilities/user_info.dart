import 'package:autoclub_frontend/models/car.dart';
import 'package:flutter/material.dart';

class UserData {
  TimeOfDay time;
  int currentDay;
  int money;
  Car? currentCar;
  List<Car> userCarList;
  int currUserCarId;
  List<Map<String, dynamic>> usedListings;

  UserData({
    required this.time,
    required this.currentDay,
    required this.money,
    this.currentCar,
    required this.userCarList,
    required this.currUserCarId,
    required this.usedListings,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': '${time.hour}:${time.minute}',
      'currentDay': currentDay,
      'money': money,
      'currentCar': currentCar?.toMap(),
      'userCarList': userCarList.map((car) => car.toMap()).toList(),
      'currUserCarId': currUserCarId,
      'usedListings': usedListings,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      currentDay: map['currentDay'],
      money: map['money'],
      currentCar:
          map['currentCar'] != null ? Car.fromMap(map['currentCar']) : null,
      userCarList:
          List<Car>.from(map['userCarList']?.map((x) => Car.fromMap(x))),
      currUserCarId: map['currUserCarId'],
      usedListings: List<Map<String, dynamic>>.from(map['usedListings']),
    );
  }
}
