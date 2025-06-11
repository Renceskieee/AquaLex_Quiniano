import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/marine_species.dart';

class MarineSpeciesService {
  Future<List<MarineSpecies>> loadMarineSpecies() async {
    final rawCsv = await rootBundle.loadString('assets/data/marine_species.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawCsv);

    final List<MarineSpecies> species = [];
    for (int i = 1; i < listData.length; i++) {
      species.add(MarineSpecies.fromList(listData[i]));
    }
    return species;
  }
} 