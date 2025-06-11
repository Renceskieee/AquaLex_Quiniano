import 'package:hive/hive.dart';

part 'marine_species.g.dart';

@HiveType(typeId: 0)
class MarineSpecies {
  @HiveField(0)
  final String photoPath;
  @HiveField(1)
  final String scientificName;
  @HiveField(2)
  final String localName;
  @HiveField(3)
  final String group;
  @HiveField(4)
  final String habitat;
  @HiveField(5)
  final String averageSize;
  @HiveField(6)
  final String threatLevel;
  @HiveField(7)
  final String legalCatchSize;
  @HiveField(8)
  final String closedSeason;
  @HiveField(9)
  final String gearRestriction;

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

  factory MarineSpecies.fromList(List<dynamic> data) {
    return MarineSpecies(
      photoPath: data[0],
      scientificName: data[1],
      localName: data[2],
      group: data[3],
      habitat: data[4],
      averageSize: data[5],
      threatLevel: data[6],
      legalCatchSize: data[7],
      closedSeason: data[8],
      gearRestriction: data[9],
    );
  }

  bool hasClosedSeasonInMonth(String monthName) {
    if (closedSeason.toLowerCase() == 'none' || closedSeason.isEmpty) {
      return false;
    }

    final monthMap = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
    };

    final monthNumber = monthMap[monthName.toLowerCase()];
    if (monthNumber == null) return false;

    if (closedSeason.contains('-')) {
      final parts = closedSeason.split('-');
      final startMonth = monthMap[parts[0].toLowerCase()];
      final endMonth = monthMap[parts[1].toLowerCase()];

      if (startMonth != null && endMonth != null) {
        if (startMonth <= endMonth) {
          return monthNumber >= startMonth && monthNumber <= endMonth;
        } else {
          return monthNumber >= startMonth || monthNumber <= endMonth;
        }
      }
    } else {
      return monthMap[closedSeason.toLowerCase()] == monthNumber;
    }
    return false;
  }
} 