import 'package:flutter/material.dart';
import 'nfz.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(78, 215, 241, 1),
          title: Center(
            child: Image.asset(
              'assets/images/AquaLex_Combo2.png',
              height: 50.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Corals.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                DashboardCard(
                  iconPath: 'assets/icons/book.png',
                  text: 'Marine Species Almanac',
                  onTap: () {
                  },
                ),
                const SizedBox(height: 20.0),
                DashboardCard(
                  iconPath: 'assets/icons/camera.png',
                  text: 'Species ID Scanner',
                  onTap: () {
                  },
                ),
                const SizedBox(height: 20.0),
                DashboardCard(
                  iconPath: 'assets/icons/calendar.png',
                  text: 'Breeding Calendar',
                  onTap: () {
                  },
                ),
                const SizedBox(height: 20.0),
                DashboardCard(
                  iconPath: 'assets/icons/compass.png',
                  text: 'No-Fishing Zones',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NFZScreen()),
                    );
                  },
                ),
                const SizedBox(height: 380.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  final String iconPath;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(173, 232, 250, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 40.0,
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 107, 0, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
