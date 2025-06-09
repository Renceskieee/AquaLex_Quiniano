import 'package:hive/hive.dart';

part 'marine_species.g.dart';

@HiveType(typeId: 0)
class MarineSpecies extends HiveObject {
  @HiveField(0)
  String photoPath;
  @HiveField(1)
  String scientificName;
  @HiveField(2)
  String localName;
  @HiveField(3)
  String group;
  @HiveField(4)
  String habitat;
  @HiveField(5)
  String averageSize;
  @HiveField(6)
  String threatLevel;
  @HiveField(7)
  String legalCatchSize;
  @HiveField(8)
  String closedSeason;
  @HiveField(9)
  String gearRestriction;

  MarineSpecies({
    required this.photoPath,
    required this.scientificName,
    required this.localName,
    required this.group,
    required this.habitat,
    required this.averageSize,
    required this.threatLevel,
    required this.legalCatchSize,
    required this.closedSeason,
    required this.gearRestriction,
  });
}
