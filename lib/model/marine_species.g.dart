part of 'marine_species.dart';

class MarineSpeciesAdapter extends TypeAdapter<MarineSpecies> {
  @override
  final int typeId = 0;

  @override
  MarineSpecies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MarineSpecies(
      photoPath: fields[0] as String,
      scientificName: fields[1] as String,
      localName: fields[2] as String,
      group: fields[3] as String,
      habitat: fields[4] as String,
      averageSize: fields[5] as String,
      threatLevel: fields[6] as String,
      legalCatchSize: fields[7] as String,
      closedSeason: fields[8] as String,
      gearRestriction: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MarineSpecies obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.photoPath)
      ..writeByte(1)
      ..write(obj.scientificName)
      ..writeByte(2)
      ..write(obj.localName)
      ..writeByte(3)
      ..write(obj.group)
      ..writeByte(4)
      ..write(obj.habitat)
      ..writeByte(5)
      ..write(obj.averageSize)
      ..writeByte(6)
      ..write(obj.threatLevel)
      ..writeByte(7)
      ..write(obj.legalCatchSize)
      ..writeByte(8)
      ..write(obj.closedSeason)
      ..writeByte(9)
      ..write(obj.gearRestriction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarineSpeciesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
