// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/allergiesComponents/DetailRSPage.dart';

class RekomendasiRSPage extends StatefulWidget {
  const RekomendasiRSPage({super.key});

  @override
  State<RekomendasiRSPage> createState() => _RekomendasiRSPageState();
}

class _RekomendasiRSPageState extends State<RekomendasiRSPage> {
  List<String> hospitalIDs = [];

  Future<List<Map<String, dynamic>>> getHospitalData() async {
    List<Map<String, dynamic>> hospital = [];
    await FirebaseFirestore.instance
        .collection('hospital')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              hospital.add(doc.data());
            }));
    return hospital;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hospital Recommendations',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                'Find the best hospital to get your allergy checked',
                style: TextStyle(fontSize: 15, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintText: 'Search for Hospital',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Outfit'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getHospitalData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Column(
                      children: snapshot.data!
                          .map((hospitalData) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15),
                                child: rsBox(hospitalData),
                              ))
                          .toList(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rsBox(Map<String, dynamic> hospitalData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRSPage(
                image: hospitalData['image'],
                hospitalName: hospitalData['hospitalName'],
                about: hospitalData['about'],
                hospitalAddress: hospitalData['hospitalAddress'],
                email: hospitalData['email'],
                telepon: hospitalData['telepon'],
                website: hospitalData['website'],
              ),
            ));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              hospitalData['image'],
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalData['hospitalName'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    hospitalData['hospitalAddress'],
                    style: const TextStyle(color: Colors.grey, fontFamily: 'Outfit'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
