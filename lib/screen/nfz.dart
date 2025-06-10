// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import '../modal/place.dart';

class NFZScreen extends StatefulWidget {
  const NFZScreen({super.key});

  @override
  State<NFZScreen> createState() => _NFZScreenState();
}

class _NFZScreenState extends State<NFZScreen> {
  final List<Place> sites = const [
    Place(
      name: 'Apo Reef Natural Park',
      lat: 12.67069445,
      lng: 120.47882073025913,
      address: 'Sablayan, Occidental Mindoro, Philippines',
      imagePath: 'assets/images/ApoReefNaturalPark.jpg',
    ),
    Place(
      name: 'Biri‑LaRoSa Protected Landscape and Seascape',
      lat: 12.61290135,
      lng: 124.4120397072083,
      address: 'Biri, Northern Samar, Philippines',
      imagePath: 'assets/images/Biri‑LaRoSaProtectedLandscapeandSeascape.jpg',
    ),
    Place(
      name: 'Bulusan Volcano',
      lat: 12.7691979,
      lng: 124.0554663783345,
      address: 'Sorsogon, Bicol Region, Philippines',
      imagePath: 'assets/images/BulusanVolcano.jpg',
    ),
    Place(
      name: 'Hundred Islands National Park',
      lat: 16.19999415,
      lng: 120.03095185006258,
      address: 'Alaminos, Pangasinan, Philippines',
      imagePath: 'assets/images/HundredIslandsNationalPark.jpg',
    ),
    Place(
      name: 'Initao–Libertad Protected Landscape and Seascape',
      lat: 8.5489026,
      lng: 124.31516102576362,
      address: 'Initao, Misamis Oriental, Philippines',
      imagePath: 'assets/images/Initao–LibertadProtectedLandscapeandSeascape.jpg',
    ),
    Place(
      name: 'Malabungot Protected Landscape and Seascape',
      lat: 13.9246392,
      lng: 123.59052125458714,
      address: 'Siruma, Camarines Sur, Philippines',
      imagePath: 'assets/images/MalabungotProtectedLandscapeandSeascape.jpg',
    ),
    Place(
      name: 'Mayon Volcano Natural Park',
      lat: 13.2592315,
      lng: 123.68451267176907,
      address: 'Albay, Bicol Region, Philippines',
      imagePath: 'assets/images/MayonVolcanoNaturalPark.jpg',
    ),
    Place(
      name: 'Tubbataha Reefs Natural Park',
      lat: 8.9240556,
      lng: 119.90936892981657,
      address: 'Cagayancillo, Palawan, Philippines',
      imagePath: 'assets/images/TubbatahaReefsNaturalPark.jpg',
    ),
    Place(
      name: 'Turtle Islands Heritage Protected Area',
      lat: 6.16186875,
      lng: 118.12395678254114,
      address: 'Turtle Islands, Tawi-Tawi, Philippines',
      imagePath: 'assets/images/TurtleIslandsHeritageProtectedArea.jpg',
    ),
  ];

  late final MapController _mapController = MapController();
  double _currentZoom = 5.7;

  void _showPlaceModal(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                place.imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              place.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text('Latitude: ${place.lat}', style: const TextStyle(fontFamily: 'Poppins')),
            Text('Longitude: ${place.lng}', style: const TextStyle(fontFamily: 'Poppins')),
            Text(place.address, style: const TextStyle(fontFamily: 'Poppins')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
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
              'No-Fishing Zones',
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
              'No-Fishing Zones',
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
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(12.8797, 121.7740),
              zoom: _currentZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.aqualex',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              MarkerLayer(
                markers: sites.map((place) {
                  return Marker(
                    width: 40,
                    height: 40,
                    point: LatLng(place.lat, place.lng),
                    child: GestureDetector(
                      onTap: () => _showPlaceModal(context, place),
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
