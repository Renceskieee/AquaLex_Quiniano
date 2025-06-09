import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/marine_species.dart';
import '../modal/species.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class MSAScreen extends StatefulWidget {
  const MSAScreen({super.key});

  @override
  State<MSAScreen> createState() => _MSAScreenState();
}

class _MSAScreenState extends State<MSAScreen> {
  List<MarineSpecies> _species = [];
  String _search = '';
  late Box<MarineSpecies> _speciesBox;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _speciesBox = Hive.box<MarineSpecies>('marine_species');
    if (_speciesBox.isEmpty) {
      await importSpeciesFromCSVToHive();
    }
    await _loadSpecies();
  }

  Future<void> _loadSpecies() async {
    setState(() {
      _species = _speciesBox.values.toList();
    });
  }

  void _showSpeciesModal(BuildContext context, MarineSpecies species) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: SpeciesModal(species: species),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _species.where((s) =>
      s.scientificName.toLowerCase().contains(_search.toLowerCase()) ||
      s.localName.toLowerCase().contains(_search.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Stack(
          children: [
            Text(
              'Marine Species Almanac',
              style: TextStyle(
                fontFamily: 'Arturo',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.black,
              ),
            ),
            const Text(
              'Marine Species Almanac',
              style: TextStyle(
                fontFamily: 'Arturo',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Species',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final s = filtered[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(78, 215, 241, 0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        s.localName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        s.scientificName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white70,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () => _showSpeciesModal(context, s),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> importSpeciesFromCSVToHive() async {
  final box = Hive.box<MarineSpecies>('marine_species');
  if (box.isNotEmpty) return;

  final rawData = await rootBundle.loadString('assets/data/marine_species.csv');
  final List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData, eol: '\n');

  for (int i = 1; i < csvData.length; i++) {
    final row = csvData[i];
    final species = MarineSpecies(
      photoPath: row[0] ?? '',
      scientificName: row[1] ?? '',
      localName: row[2] ?? '',
      group: row[3] ?? '',
      habitat: row[4] ?? '',
      averageSize: row[5] ?? '',
      threatLevel: row[6] ?? '',
      legalCatchSize: row[7] ?? '',
      closedSeason: row[8] ?? '',
      gearRestriction: row[9] ?? '',
    );
    await box.add(species);
  }
}
