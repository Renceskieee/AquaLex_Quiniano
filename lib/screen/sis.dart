// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../models/marine_species.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:typed_data';
import '../modal/result.dart';

class SISScreen extends StatefulWidget {
  const SISScreen({super.key});

  @override
  State<SISScreen> createState() => _SISScreenState();
}

class _SISScreenState extends State<SISScreen> {
  List<MarineSpecies> _allSpecies = [];
  late Box<MarineSpecies> _speciesBox;
  bool _isLoading = true;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _speciesBox = await Hive.openBox<MarineSpecies>('marine_species');
    if (_speciesBox.isEmpty) {
      await _importSpeciesFromCSVToHive();
    }
    _loadAllSpecies();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadAllSpecies() async {
    setState(() {
      _allSpecies = _speciesBox.values.toList();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageBytes = await pickedFile.readAsBytes();
      _showResultModal(pickedFile, _imageBytes);
    }
  }

  Future<void> _importSpeciesFromCSVToHive() async {
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
      await _speciesBox.add(species);
    }
  }

  void _showResultModal(XFile? pickedImage, Uint8List? pickedImageBytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: ResultScreen(
            image: pickedImage,
            imageBytes: pickedImageBytes,
            allSpecies: _allSpecies,
          ),
        ),
      ),
    ).whenComplete(() {
      setState(() {
        _imageBytes = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Stack(
          children: [
            Text(
              'Species ID Scanner',
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
              'Species ID Scanner',
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
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(78, 215, 241, 0.9),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/camera2.png',
                          width: 80,
                          height: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Take a photo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(78, 215, 241, 1),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/upload.png',
                          width: 80,
                          height: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Upload a photo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
