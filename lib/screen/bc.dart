import 'package:flutter/material.dart';
import 'package:aqualex/services/marine_species_service.dart';
import 'package:aqualex/models/marine_species.dart';
import 'package:aqualex/screen/monthly_breeding_schedule_screen.dart';

class BCScreen extends StatefulWidget {
  const BCScreen({super.key});

  @override
  State<BCScreen> createState() => _BCScreenState();
}

class _BCScreenState extends State<BCScreen> {
  late Future<List<MarineSpecies>> _marineSpeciesFuture;

  @override
  void initState() {
    super.initState();
    _marineSpeciesFuture = MarineSpeciesService().loadMarineSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Stack(
          children: [
            Text(
              'Breeding Calendar',
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
              'Breeding Calendar',
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
      body: FutureBuilder<List<MarineSpecies>>(
        future: _marineSpeciesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No marine species data found.'));
          } else {
            final marineSpeciesList = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: List.generate(12, (index) {
                final monthNames = [
                  'january',
                  'february',
                  'march',
                  'april',
                  'may',
                  'june',
                  'july',
                  'august',
                  'september',
                  'october',
                  'november',
                  'december',
                ];
                final month = monthNames[index];
                final capitalizedMonth = '${month[0].toUpperCase()}${month.substring(1)}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthlyBreedingScheduleScreen(
                          monthName: capitalizedMonth,
                          marineSpeciesList: marineSpeciesList,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'assets/icons/$month.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
