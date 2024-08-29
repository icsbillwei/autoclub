import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/models/job.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';

class CarRequirement {
  final String name;
  final bool Function(Car) check;

  CarRequirement({required this.name, required this.check});
}

/*
  Some job requirement utilities
*/

// Basic utils

final CarRequirement hasCar = CarRequirement(
  name: "Driving a vehicle",
  check: (Car car) => true,
);

final CarRequirement noBrokenCriticalComponents = CarRequirement(
  name: "Vehicle has no broken critical components",
  check: (Car car) {
    return car.hasBrokenComponents();
  },
);

final CarRequirement fourSeats = CarRequirement(
  name: "Vehicle has at least 4 seats",
  check: (Car car) {
    return car.seatCount >= 4;
  },
);

final CarRequirement fiveSeats = CarRequirement(
  name: "Vehicle has at least 5 seats",
  check: (Car car) {
    return car.seatCount >= 5;
  },
);

final CarRequirement sixSeats = CarRequirement(
  name: "Vehicle has at least 6 seats",
  check: (Car car) {
    return car.seatCount >= 6;
  },
);

// damage utils

final CarRequirement noBrokenComponents = CarRequirement(
  name: "Vehicle has no broken components",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage == ComponentDamage.broken) {
        return false;
      }
    }
    return true;
  },
);

final CarRequirement noSevereComponents = CarRequirement(
  name: "Vehicle has no severely damaged components",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage.level >= 3) {
        return false;
      }
    }
    return true;
  },
);

final CarRequirement noMediumComponents = CarRequirement(
  name: "Vehicle has no medium or worsely damaged components",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage.level >= 2) {
        return false;
      }
    }
    return true;
  },
);

final CarRequirement noDamage = CarRequirement(
  name: "Vehicle has no damage",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage != ComponentDamage.none) {
        return false;
      }
    }
    return true;
  },
);

// body damage utils

final CarRequirement noBodyDamage = CarRequirement(
  name: "Vehicle has no body damage",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage != ComponentDamage.none &&
          component.name == "Bodywork") {
        return false;
      }
    }
    return true;
  },
);

final CarRequirement noMediumBodyDamage = CarRequirement(
  name: "Vehicle has no Medium or worse body damage",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage == ComponentDamage.light &&
          component.name == "Bodywork") {
        return false;
      }
    }
    return true;
  },
);

// interior damage utils

final CarRequirement noInteriorDamage = CarRequirement(
  name: "Vehicle has no interior damage",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage != ComponentDamage.none &&
          component.name == "Interior") {
        return false;
      }
    }
    return true;
  },
);

final CarRequirement noMediumInteriorDamage = CarRequirement(
  name: "Vehicle has no medium or worse interior damage",
  check: (Car car) {
    for (var component in car.componentList) {
      if (component.damage == ComponentDamage.light &&
          component.name == "Interior") {
        return false;
      }
    }
    return true;
  },
);

// cargo space utils

final CarRequirement medCargoSpace = CarRequirement(
  name: "At least having medium cargo space",
  check: (Car car) {
    return car.space.size >= 3;
  },
);

final CarRequirement smallCargoSpace = CarRequirement(
  name: "At least having small cargo space",
  check: (Car car) {
    return car.space.size >= 2;
  },
);

final CarRequirement largeCargoSpace = CarRequirement(
  name: "At least having large cargo space",
  check: (Car car) {
    return car.space.size >= 4;
  },
);

final CarRequirement extraLargeCargoSpace = CarRequirement(
  name: "At least having extra large cargo space",
  check: (Car car) {
    return car.space.size >= 5;
  },
);

final CarRequirement xxlCargoSpace = CarRequirement(
  name: "At least having XXL cargo space",
  check: (Car car) {
    return car.space.size == 6;
  },
);

// Car Type utils

final CarRequirement isSedan = CarRequirement(
  name: "Vehicle is a sedan",
  check: (Car car) {
    return car.type == CarType.sedan;
  },
);

final CarRequirement isHatchback = CarRequirement(
  name: "Vehicle is a hatchback",
  check: (Car car) {
    return car.type == CarType.hatchback;
  },
);

final CarRequirement isSUV = CarRequirement(
  name: "Vehicle is an SUV",
  check: (Car car) {
    return car.type == CarType.suv;
  },
);

final CarRequirement isPickup = CarRequirement(
  name: "Vehicle is a pickup",
  check: (Car car) {
    return car.type == CarType.pickup;
  },
);

final CarRequirement isVan = CarRequirement(
  name: "Vehicle is a van",
  check: (Car car) {
    return car.type == CarType.van;
  },
);

final CarRequirement isMinivan = CarRequirement(
  name: "Vehicle is a minivan",
  check: (Car car) {
    return car.type == CarType.minivan;
  },
);

// Car Tag utils

final CarRequirement isClassic = CarRequirement(
  name: "Vehicle is a classic",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.classic) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isTuner = CarRequirement(
  name: "Vehicle is a tuner",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.tuner) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isMuscle = CarRequirement(
  name: "Vehicle is a muscle car",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.muscle) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isPremium = CarRequirement(
  name: "Vehicle is a premium car",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.premium) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isLuxury = CarRequirement(
  name: "Vehicle is a luxury car",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.luxury) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isSuperLuxury = CarRequirement(
  name: "Vehicle is a super luxury car",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.superLuxury) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isComfortTaxi = CarRequirement(
  name: "Vehicle qualify as a comfort taxi",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.comfortTaxi) {
        return true;
      }
    }
    return false;
  },
);

final CarRequirement isLuxuryTaxi = CarRequirement(
  name: "Vehicle qualify as a luxury taxi",
  check: (Car car) {
    for (var tag in car.tags) {
      if (tag == CarTag.luxuryTaxi) {
        return true;
      }
    }
    return false;
  },
);
