enum SelectedLocation {
  undefined,
  downtown,
  home,
  hotel,
  showroom,
  tuning,
  wharf
}

extension SelectedLocationExtension on SelectedLocation {
  String get name {
    switch (this) {
      case SelectedLocation.undefined:
        return 'Undefined';
      case SelectedLocation.downtown:
        return 'Downtown';
      case SelectedLocation.home:
        return 'Home';
      case SelectedLocation.hotel:
        return 'Hotel';
      case SelectedLocation.showroom:
        return 'Showroom';
      case SelectedLocation.tuning:
        return 'AT Auto';
      case SelectedLocation.wharf:
        return 'Wharf';
      default:
        return '';
    }
  }
}

/*
Map matrix representing the distances between each places
*/
final Map<SelectedLocation, Map<SelectedLocation, int>> locationDistances = {
  SelectedLocation.downtown: {
    SelectedLocation.home: 20,
    SelectedLocation.hotel: 20,
    SelectedLocation.showroom: 28,
    SelectedLocation.tuning: 45,
    SelectedLocation.wharf: 35,
  },
  SelectedLocation.home: {
    SelectedLocation.downtown: 20,
    SelectedLocation.hotel: 28,
    SelectedLocation.showroom: 20,
    SelectedLocation.tuning: 25,
    SelectedLocation.wharf: 55,
  },
  SelectedLocation.hotel: {
    SelectedLocation.downtown: 20,
    SelectedLocation.home: 28,
    SelectedLocation.showroom: 18,
    SelectedLocation.tuning: 48,
    SelectedLocation.wharf: 44,
  },
  SelectedLocation.showroom: {
    SelectedLocation.downtown: 28,
    SelectedLocation.home: 20,
    SelectedLocation.hotel: 18,
    SelectedLocation.tuning: 34,
    SelectedLocation.wharf: 62,
  },
  SelectedLocation.tuning: {
    SelectedLocation.downtown: 45,
    SelectedLocation.home: 25,
    SelectedLocation.hotel: 48,
    SelectedLocation.showroom: 34,
    SelectedLocation.wharf: 80,
  },
  SelectedLocation.wharf: {
    SelectedLocation.downtown: 35,
    SelectedLocation.home: 55,
    SelectedLocation.hotel: 44,
    SelectedLocation.showroom: 62,
    SelectedLocation.tuning: 80,
  },
};

int getDistance(SelectedLocation from, SelectedLocation to) {
  return locationDistances[from]?[to] ?? 0;
}

Map<String, int> getTravelTime(SelectedLocation from, SelectedLocation to) {
  const double averageSpeed = 50.0; // km/h
  int distance = getDistance(from, to);
  double timeInHours = distance / averageSpeed;

  int hours = timeInHours.floor();
  int minutes = ((timeInHours - hours) * 60).round();

  return {
    'hours': hours,
    'minutes': minutes,
  };
}

int getTravelTimeInMinutes(SelectedLocation from, SelectedLocation to) {
  const double averageSpeed = 50.0; // km/h
  int distance = getDistance(from, to);
  double timeInHours = distance / averageSpeed;

  return (timeInHours * 60).round();
}
