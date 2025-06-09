import 'package:flutter/material.dart';
import '../model/marine_species.dart';

class SpeciesModal extends StatelessWidget {
  final MarineSpecies species;

  const SpeciesModal({
    super.key,
    required this.species,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (species.photoPath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                species.photoPath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          if (species.photoPath.isNotEmpty)
            const SizedBox(height: 16),
          Text(
            species.localName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            species.scientificName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontStyle: FontStyle.italic,
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Group', species.group),
          _buildInfoRow('Habitat', species.habitat),
          _buildInfoRow('Average Size', species.averageSize),
          _buildInfoRow('Threat Level', species.threatLevel),
          _buildInfoRow('Legal Catch Size', species.legalCatchSize),
          _buildInfoRow('Closed Season', species.closedSeason),
          _buildInfoRow('Gear Restriction', species.gearRestriction),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
