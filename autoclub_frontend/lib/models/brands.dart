

import 'car.dart';

class Brand {
  String name;
  String imgPath;
  bool unlocked;
  int affinity;
  List<CarModel> carList;

  Brand(this.name, this.imgPath, this.unlocked, this.affinity, this.carList);

}