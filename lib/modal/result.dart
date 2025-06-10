// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../model/marine_species.dart';
import '../modal/species.dart';

class ResultScreen extends StatefulWidget {
  final XFile? image;
  final Uint8List? imageBytes;
  final List<MarineSpecies> allSpecies;

  const ResultScreen({
    super.key,
    required this.image,
    this.imageBytes,
    required this.allSpecies,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  MarineSpecies? _identifiedSpecies;
  bool _isIdentifying = false;
  bool _hasPredicted = false;

  String? _selectedGroup;
  String? _selectedHabitat;
  String? _inputAverageSize;
  double? _predictionPercentage;

  late TextEditingController _averageSizeController;

  List<String> _groups = [];
  List<String> _habitats = [];

  @override
  void initState() {
    super.initState();
    _averageSizeController = TextEditingController();
    _resetIdentificationState();
    _populateDropdownValues();
  }

  @override
  void dispose() {
    _averageSizeController.dispose();
    super.dispose();
  }

  void _populateDropdownValues() {
    _groups = widget.allSpecies.map((s) => s.group).toSet().toList();
    _habitats = widget.allSpecies.map((s) => s.habitat).toSet().toList();

    _groups.sort();
    _habitats.sort();
  }

  Future<void> _resetIdentificationState() async {
    setState(() {
      _isIdentifying = false;
      _identifiedSpecies = null;
      _predictionPercentage = null;
      _averageSizeController.clear();
      _inputAverageSize = null;
      _hasPredicted = false;
    });
  }

  double? _normalizeSize(String? sizeString) {
    if (sizeString == null || sizeString.isEmpty) return null;
    sizeString = sizeString.toLowerCase().trim();

    RegExp cmRegex = RegExp(r'(\d+\.?\d*)\s*cm');
    RegExp meterRegex = RegExp(r'(\d+\.?\d*)\s*m');

    if (cmRegex.hasMatch(sizeString)) {
      return double.tryParse(cmRegex.firstMatch(sizeString)!.group(1)!);
    } else if (meterRegex.hasMatch(sizeString)) {
      return (double.tryParse(meterRegex.firstMatch(sizeString)!.group(1)!) ?? 0.0) * 100;
    } else {
      return double.tryParse(sizeString);
    }
  }

  void _predictSpecies() {
    setState(() {
      _isIdentifying = true;
      _inputAverageSize = _averageSizeController.text;
      _hasPredicted = true;
    });

    double? normalizedInputSize = _normalizeSize(_inputAverageSize);

    List<MarineSpecies> potentialMatches = widget.allSpecies.where((species) {
      bool matchesGroup = _selectedGroup == null || species.group == _selectedGroup;
      bool matchesHabitat = _selectedHabitat == null || species.habitat == _selectedHabitat;

      double? normalizedSpeciesSize = _normalizeSize(species.averageSize);

      bool matchesAverageSize = true;
      if (normalizedInputSize != null && normalizedSpeciesSize != null) {
        double tolerance = normalizedSpeciesSize * 0.2;
        matchesAverageSize = (normalizedInputSize - normalizedSpeciesSize).abs() <= tolerance;
      } else if (normalizedInputSize != null && normalizedSpeciesSize == null) {
        matchesAverageSize = false;
      } else if (normalizedInputSize == null && normalizedSpeciesSize != null) {
        matchesAverageSize = true;
      } else if (normalizedInputSize == null && normalizedSpeciesSize == null) {
        matchesAverageSize = true;
      }

      return matchesGroup && matchesHabitat && matchesAverageSize;
    }).toList();

    if (potentialMatches.isEmpty) {
      setState(() {
        _identifiedSpecies = null;
        _predictionPercentage = 0.0;
        _isIdentifying = false;
      });
      return;
    }

    MarineSpecies? bestMatch;
    double maxScore = -1;

    for (var species in potentialMatches) {
      double currentScore = 0;
      if (_selectedGroup != null && species.group == _selectedGroup) currentScore++;
      if (_selectedHabitat != null && species.habitat == _selectedHabitat) currentScore++;

      double? normalizedSpeciesSize = _normalizeSize(species.averageSize);
      if (_inputAverageSize != null && normalizedInputSize != null && normalizedSpeciesSize != null) {
        double sizeDifference = (normalizedInputSize - normalizedSpeciesSize).abs();
        double tolerance = normalizedSpeciesSize * 0.2;
        if (sizeDifference <= tolerance) {
          double sizeMatchScore = 1.0 - (sizeDifference / tolerance);
          currentScore += sizeMatchScore;
        }
      }

      if (currentScore > maxScore) {
        maxScore = currentScore;
        bestMatch = species;
      }
    }

    int selectedCriteriaCount = 0;
    if (_selectedGroup != null) selectedCriteriaCount++;
    if (_selectedHabitat != null) selectedCriteriaCount++;
    if (_inputAverageSize != null && _inputAverageSize!.isNotEmpty) selectedCriteriaCount++;

    double percentage = 0.0;
    if (selectedCriteriaCount > 0) {
      percentage = (maxScore / selectedCriteriaCount) * 100;
    }

    setState(() {
      _identifiedSpecies = bestMatch;
      _predictionPercentage = percentage;
      _isIdentifying = false;
    });

    debugPrint('*** _predictSpecies finished ***');
    debugPrint('  _identifiedSpecies: $_identifiedSpecies');
    debugPrint('  _predictionPercentage: $_predictionPercentage');
    debugPrint('  _hasPredicted: $_hasPredicted');
    debugPrint('  _isIdentifying: $_isIdentifying');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('*** ResultScreen build called ***');
    debugPrint('  _isIdentifying: $_isIdentifying');
    debugPrint('  _hasPredicted: $_hasPredicted');
    debugPrint('  _identifiedSpecies: $_identifiedSpecies');
    debugPrint('  _predictionPercentage: $_predictionPercentage');
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Results',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color.fromRGBO(78, 215, 241, 1),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: kIsWeb
                  ? (widget.imageBytes != null
                      ? Image.memory(
                          widget.imageBytes!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink())
                  : Image.file(
                      File(widget.image!.path),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  _buildDropdown(
                    'Group',
                    _groups,
                    _selectedGroup,
                    (String? newValue) {
                      setState(() {
                        _selectedGroup = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    'Habitat',
                    _habitats,
                    _selectedHabitat,
                    (String? newValue) {
                      setState(() {
                        _selectedHabitat = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _averageSizeController,
                    decoration: InputDecoration(
                      hintText: 'Average Size',
                      suffixText: 'cm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _inputAverageSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _predictSpecies,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Predict Species',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isIdentifying) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                'Predicting species...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ] else if (_identifiedSpecies != null && _predictionPercentage != null && _predictionPercentage! >= 50) ...[
              Text(
                _identifiedSpecies!.localName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                'Confidence: ${_predictionPercentage!.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
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
                        child: SpeciesModal(species: _identifiedSpecies!),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'View information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else if (_hasPredicted) ...[
              const Text(
                'No match found.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hintText,
    List<String> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedValue,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontFamily: 'Poppins')),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
