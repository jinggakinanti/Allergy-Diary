// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Page/ChatPage.dart';
import 'package:project/Page/CheckAllergiesPage.dart';
import 'package:project/Page/ConsultationPage.dart';
import 'package:project/Page/ForumPage.dart';
import 'package:project/Page/ProfilePage.dart';
import 'package:project/Page/ScanPage.dart';
import 'package:project/components/DoctorProfile.dart';
import 'package:project/page/MedicinePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;
  late PageController _pageController;
  bool isDoctorProfile =
      FirebaseAuth.instance.currentUser?.email == 'jane.abigail@allergy.diary' || FirebaseAuth.instance.currentUser?.email == 'james.lohan@allergy.diary';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTapped(int page) {
    setState(() {
      selectedPage = page;
      _pageController.animateToPage(selectedPage,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            selectedPage = page;
          });
        },
        children: [
          home(),
          ForumPage(),
          ScanPage(),
          ChatPage(),
          profileSelect()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: onItemTapped,
          currentIndex: selectedPage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.forum_rounded), label: 'Forum'),
            BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined), label: 'Scan'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          backgroundColor: const Color.fromRGBO(71, 116, 186, 1)),
    );
  }

  Widget home() {
    double height = MediaQuery.of(context).size.height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(children: [
                  Container(
                    height: height,
                    color: Color.fromRGBO(71, 116, 186, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'image/Logo.png',
                            width: 90,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            'Be aware of your allergies',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Lemon'),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),
                ]),
                Positioned(
                  top: height - 30,
                  left: (MediaQuery.of(context).size.width - 350) / 2,
                  child: Container(
                      width: 350,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildMainButton(
                              'image/CheckAllergies.png',
                              'Check allergies',
                              Color.fromRGBO(71, 116, 186, 100), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckAllergiesPage(),
                                ));
                          }),
                          buildMainButton(
                              'image/Consultation.png',
                              'Consultation',
                              Color.fromRGBO(227, 78, 66, 100), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConsultationPage()));
                          }),
                          buildMainButton('image/Medicine.png', 'Medicine',
                              Color.fromRGBO(117, 192, 56, 100), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicinePage(),
                                ));
                          }),
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Daily Check-In',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
                width: 350,
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'How is your condition today?',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit'),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildEmojiColumn('😫', 'Bad\n'),
                        buildEmojiColumn('😟', 'Not so\ngood'),
                        buildEmojiColumn('😐', 'Normal\n'),
                        buildEmojiColumn('😊', 'Good\nenough'),
                        buildEmojiColumn('😃', 'Very\ngood'),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget buildMainButton(
      String imagePath, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: color.withOpacity(1),
              child:
                  Center(child: Image.asset(imagePath, height: 30, width: 30)),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontFamily: 'Outfit'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmojiColumn(String emoji, String label) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontFamily: 'Outfit'),
          )
        ],
      ),
    );
  }

  Widget profileSelect() {
    if (isDoctorProfile) {
      return DocterProfilePage();
    } else {
      return ProfilePage();
    }
  }
}
