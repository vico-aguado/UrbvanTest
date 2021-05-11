import 'package:flutter/material.dart';
import 'package:urbvan/app/screens/issLocation_screen.dart';
import 'package:urbvan/app/screens/routes_screen.dart';
import 'package:urbvan/configuration.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int _sectionSelected = 0;

  final List<Widget> _sections = [
   ISSLocationScreen(),
   RoutesScreen()
 ];

  void _onTabTapped(int index) {
    setState(() {
      _sectionSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Urbvan Test",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w900,
            color: red_light_color,
          ),
        ),
      ),
      body: _sections[_sectionSelected],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _sectionSelected,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: red_light_color,
        selectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Image.asset("assets/images/satelite.png", height: 30, color: _sectionSelected == 0 ? red_light_color : Colors.grey ,),
            ),
            label: 'ISS Location',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Image.asset("assets/images/route.png", height: 30, color: _sectionSelected == 1 ? red_light_color : Colors.grey ,),
            ),
            label: 'Rutas',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
