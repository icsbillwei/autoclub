enum CarType {
  /*
Body types of car objects
 */

  sedan(name: "Sedan"),
  hatchback(name: "Hatchback"),
  wagon(name: "Wagon"),
  suv(name: "SUV"),
  coupe(name: "Coupe"),
  convertible(name: "Convertible"),
  microcar(name: "Microcar"),
  minivan(name: "Minivan"),
  van(name: "Box van"),
  pickup(name: "Pickup"),
  supercar(name: "Supercar"),
  hypercar(name: "Hypercar"),

  // For cars that do not fall under any of the above categories
  special(name: "Special");

  final String name;
  // possible todo: add icons
  const CarType({required this.name});
}

enum CarTag {
  /*
  Tags for car objects.
  Used to specify attributes of the cars.
 */

  classic(name: "Classic"),
  tuner(name: "Tuner"),
  muscle(name: "Muscle"),
  premium(name: "Premium"),
  luxury(name: "Luxury"),
  gt(name: "Grand tourer"),
  superLuxury(name: "Super Luxury"),
  kei(name: "Kei car"),
  race(name: "Race"),
  utility(name: "Utility"),
  sport(name: "Sport"),
  none(name: "None"), // placeholder for cars with no tag: 11
  trackToy(name: "Track toy"),
  extremeTrackToy(name: "Extreme track toy"),
  homologation(name: "Homologation"),
  preTuned(name: "Pre-tuned"),
  hotHatch(name: "Hot hatch"),
  rally(name: "Rally"),
  offroad(name: "Off-road"),
  comfortTaxi(name: "Comfort Taxi"),
  luxuryTaxi(name: "Luxury Taxi"),
  ;

  final String name;
  const CarTag({required this.name});
}

enum Continent {
  /*
Continents for the countries.
 */

  asia,
  europe,
  northAmerica,
  africa,
  oceania,
}

enum Country {
  /*
Possible countries for the car objects.
 */

  uk(cont: Continent.europe, name: "United Kingdom"),
  japan(cont: Continent.asia, name: "Japan"),
  italy(cont: Continent.europe, name: "Italy"),
  indonesia(cont: Continent.asia, name: "Indonesia"),
  germany(cont: Continent.europe, name: "Germany"),
  finland(cont: Continent.europe, name: "Finland"),
  estonia(cont: Continent.europe, name: "Estonia"),
  poland(cont: Continent.europe, name: "Poland"),
  us(cont: Continent.northAmerica, name: "United States"),
  china(cont: Continent.asia, name: "China"),
  malaysia(cont: Continent.asia, name: "Malaysia"),
  canada(cont: Continent.northAmerica, name: "Canada"),
  france(cont: Continent.europe, name: "France"),
  southAfrica(cont: Continent.africa, name: "South Africa"),
  ;

  final Continent cont;
  final String name;
  const Country({required this.cont, required this.name});
}

enum DrivetrainType {
/*
Types of drivetrains for the cars.
 */

  ff(name: "Front engine, front wheel drive", acronym: "FF"),
  fr(name: "Front engine, rear wheel drive", acronym: "FR"),
  mr(name: "Mid engine, rear wheel drive", acronym: "MR"),
  rr(name: "Rear engine, rear wheel drive", acronym: "RR"),
  fourwd(name: "Four wheel drive", acronym: "4WD"),
  fawd(name: "Front engine, all wheel drive", acronym: "F-AWD"),
  mawd(name: "Mid engine, all wheel drive", acronym: "M-AWD"),
  rawd(name: "Rear engine, all wheel drive", acronym: "R-AWD");

  final String name;
  final String acronym;
  const DrivetrainType({required this.name, required this.acronym});
}

enum EngineType {
  /*
Types of engines for the cars.
 */

  i3(name: "I3", fullName: "Inline 3"),
  i4(name: "I4", fullName: "Inline 4"),
  i5(name: "I5", fullName: "Inline 5"),
  i6(name: "I6", fullName: "Inline 6"),
  v6(name: "V6", fullName: "V6"),
  v8(name: "V8", fullName: "V8"),
  v10(name: "V10", fullName: "V10"),
  v12(name: "V12", fullName: "V12"),
  v16(name: "V16", fullName: "V16"),
  b4(name: "B4", fullName: "Flat 4"),
  b6(name: "B6", fullName: "Flat 6"),
  ev(name: "EV", fullName: "Electric drive"),
  i8(name: "I8", fullName: "Inline 8");

  final String name;
  final String fullName;
  const EngineType({required this.name, required this.fullName});
}

enum EngineAspiration {
  /*
Types of engine aspiration for the car engines.
 */

  na(name: "Naturally Aspirated"),
  turbo(name: "Turbocharged"),
  sc(name: "Supercharged"),
  ev(name: "EV"),
  twincharge(name: "Twincharged"),
  naHybrid(name: "Naturally Aspirated + Hybrid"),
  turboHybrid(name: "Turbocharged + Hybrid");

  final String name;
  const EngineAspiration({required this.name});
}

enum CargoSpace {
  /*
Cargo space rating for the cars.
Used for mission requirements.
 */

  xs(name: "XS", size: 1),
  s(name: "S", size: 2),
  m(name: "M", size: 3),
  l(name: "L", size: 4),
  xl(name: "XL", size: 5),
  xxl(name: "XXL", size: 6);

  final String name;
  final int size;
  const CargoSpace({required this.name, required this.size});
}

enum ComponentDamage {
  /*
  Damage levels for the individual components
  With varying levels of repair cost
   */
  none(name: "None", level: 0, coef: 0),
  light(name: "Light", level: 1, coef: 0.05),
  medium(name: "Medium", level: 2, coef: 0.12),
  severe(name: "Severe", level: 3, coef: 0.4),
  broken(name: "Broken!", level: 4, coef: 0.75);

  final String name;
  final int level;

  // coefficient for the repair cost relative to the component price
  final double coef;

  const ComponentDamage(
      {required this.name, required this.coef, required this.level});
}

class Component {
  /*
  Individual components for the cars
  Used for the repairing and damaging system
  Possibly used for the upgrading system
   */

  ComponentDamage damage;
  final String name;

  // Price of component relative to new price of car
  final double ratio;

  final String description;

  Component(
      {required this.name,
      required this.damage,
      required this.ratio,
      this.description = ""});

  Component.clone(Component component)
      : name = component.name,
        damage = component.damage,
        ratio = component.ratio,
        description = component.description;

  @override
  String toString() => "$name (Damage: ${damage.toString()}, Ratio: $ratio)";
}

String getFlagAssetPath(Country country) {
  switch (country) {
    case Country.uk:
      return 'images/flags/gb.svg';
    case Country.japan:
      return 'images/flags/jp.svg';
    case Country.italy:
      return 'images/flags/it.svg';
    case Country.indonesia:
      return 'images/flags/id.svg';
    case Country.germany:
      return 'images/flags/de.svg';
    case Country.finland:
      return 'images/flags/fi.svg';
    case Country.estonia:
      return 'images/flags/ee.svg';
    case Country.poland:
      return 'images/flags/pl.svg';
    case Country.us:
      return 'images/flags/us.svg';
    case Country.china:
      return 'images/flags/cn.svg';
    case Country.malaysia:
      return 'images/flags/my.svg';
    case Country.canada:
      return 'images/flags/ca.svg';
    case Country.france:
      return 'images/flags/fr.svg';
    case Country.southAfrica:
      return 'images/flags/za.svg';
    default:
      return 'images/flags/fr.svg'; // Provide a default flag if needed
  }
}
