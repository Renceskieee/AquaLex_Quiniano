import 'package:flutter/material.dart';
import '../models/marine_species.dart';

class MonthlyBreedingScheduleScreen extends StatelessWidget {
  final String monthName;
  final List<MarineSpecies> marineSpeciesList;

  const MonthlyBreedingScheduleScreen({
    super.key,
    required this.monthName,
    required this.marineSpeciesList,
  });

  @override
  Widget build(BuildContext context) {
    final speciesInClosedSeason = marineSpeciesList
        .where((species) => species.hasClosedSeasonInMonth(monthName))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Stack(
          children: [
            Text(
              '$monthName Breeding Schedule',
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
            Text(
              '$monthName Breeding Schedule',
              style: const TextStyle(
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
        padding: const EdgeInsets.only(top: 16.0),
        child: speciesInClosedSeason.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/calendar2.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No closed seasons this month!',
                      style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: speciesInClosedSeason.length,
                itemBuilder: (context, index) {
                  final species = speciesInClosedSeason[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: const Color.fromRGBO(78, 215, 241, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            species.localName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          Text(
                            'Scientific Name: ${species.scientificName}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white70),
                          ),
                          Text(
                            'Closed Season: ${species.closedSeason}',
                            style: const TextStyle(fontSize: 16, color: Color.fromRGBO(255, 250, 141, 1), fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 