// ignore_for_file: file_names, avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/DoctorComponents/DoctorProfile.dart';
import 'package:project/components/LoginOrRegis.dart';

class DocterProfilePage extends StatefulWidget {
  const DocterProfilePage({super.key});

  @override
  _DocterProfilePageState createState() => _DocterProfilePageState();
}

class _DocterProfilePageState extends State<DocterProfilePage> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = user?.email;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('docter')
        .where('email', isEqualTo: currentUserEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      });
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Outfit'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegister(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: _userData != null
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor:
                            const Color.fromARGB(255, 149, 205, 251),
                        child: Image.network('${_userData!['image']}'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Name', style: TextStyle(fontFamily: 'Outfit')),
                    dataBox('${_userData!['name']}'),
                    const SizedBox(height: 15),
                    const Text('Email', style: TextStyle(fontFamily: 'Outfit')),
                    dataBox('${_userData!['email']}'),
                    const SizedBox(height: 15),
                    const Text('Specialist',
                        style: TextStyle(fontFamily: 'Outfit')),
                    dataBox('${_userData!['specialist']}'),
                    const SizedBox(height: 15),
                    const Text('Location',
                        style: TextStyle(fontFamily: 'Outfit')),
                    dataBox('${_userData!['location']}'),
                    const SizedBox(height: 15),
                    const Text('Experience',
                        style: TextStyle(fontFamily: 'Outfit')),
                    dataBox('${_userData!['experience']} years'),
                    const SizedBox(height: 15),
                    const Text('Education',
                        style: TextStyle(fontFamily: 'Outfit')),
                    about(),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                'Your request has been sent!',
                                style: TextStyle(fontFamily: 'Outfit'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(FontAwesomeIcons.pen, size: 15),
                          SizedBox(width: 5),
                          Text(
                            'Suggest an edit',
                            style: TextStyle(fontFamily: 'Outfit'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child:
                  Text('No data found', style: TextStyle(fontFamily: 'Outfit')),
            ),
    );
  }

  Widget dataBox(String userData) {
    Future<List<Education>> fetchEducation() async {
      User? user = FirebaseAuth.instance.currentUser;
      String? doctorEmail = user?.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('docter')
          .where('email', isEqualTo: doctorEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doctorDoc = querySnapshot.docs.first;
        CollectionReference educationRef = FirebaseFirestore.instance
            .collection('docter')
            .doc(doctorDoc.id)
            .collection('education');

        QuerySnapshot educationSnapshot =
            await educationRef.orderBy('year', descending: true).get();

        return educationSnapshot.docs
            .map((doc) => Education.fromFirestore(doc))
            .toList();
      } else {
        return [];
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromRGBO(243, 246, 250, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userData,
              style: const TextStyle(fontSize: 16, fontFamily: 'Outfit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget about() {
    Future<List<Education>> fetchEducation() async {
      User? user = FirebaseAuth.instance.currentUser;
      String? doctorEmail = user?.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('docter')
          .where('email', isEqualTo: doctorEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document for each doctor
        DocumentSnapshot doctorDoc = querySnapshot.docs.first;
        CollectionReference educationRef = FirebaseFirestore.instance
            .collection('docter')
            .doc(doctorDoc.id)
            .collection('education');

        QuerySnapshot educationSnapshot =
            await educationRef.orderBy('year', descending: true).get();

        return educationSnapshot.docs
            .map((doc) => Education.fromFirestore(doc))
            .toList();
      } else {
        // Handle the case where no doctor with the given email is found
        return [];
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: IndexedStack(
        children: [
          Column(
            children: [
              FutureBuilder<List<Education>>(
                future: fetchEducation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(fontFamily: 'Outfit')));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No education data found.',
                            style: TextStyle(fontFamily: 'Outfit')));
                  } else {
                    List<Education> educationList = snapshot.data!;
                    return Column(
                      children: educationList.map((education) {
                        return Column(
                            children:
                                List.generate(education.year.length, (index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: const Color.fromRGBO(243, 246, 250, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      education.year[index],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Outfit'),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            education.pendidikan[index],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Outfit'),
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            education.university[index],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontFamily: 'Outfit'),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }));
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
