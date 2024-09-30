// ignore_for_file: file_names, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/DoctorComponents/DoctorSchedule.dart';

class DoctorProfile extends StatefulWidget {
  final String imagePath;
  final String name;
  final String specialist;
  final String experience;
  final String price;
  final String location;
  final String doctorId;

  const DoctorProfile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.specialist,
    required this.experience,
    required this.price,
    required this.location,
    required this.doctorId,
  });

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Details',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: SingleChildScrollView(
        child: description(widget.imagePath, widget.name),
      ),
    );
  }

  Widget description(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 149, 205, 251),
              radius: 70,
              child: Image.network(imagePath)),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
          const SizedBox(height: 15),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit'
                          ),
                        ),
                        if (selectedIndex == 0)
                          Container(
                            height: 2,
                            width: 50,
                            color: Colors.black, // Warna garis seperti Divider
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        const Text(
                          'Review',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (selectedIndex == 1)
                          Container(
                            height: 2,
                            width: 50,
                            color: Colors.black, // Warna garis seperti Divider
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              about(
                widget.specialist,
                widget.experience,
                widget.price,
                widget.location,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorSchedule(doctorId: widget.doctorId, imagePath: widget.imagePath, name: widget.name, choosenDate: '', price: widget.price,),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Make Appointment',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget about(
    String specialist,
    String experience,
    String price,
    String location,
  ) {
    Future<List<Education>> fetchEducation() async {
      CollectionReference educationRef = FirebaseFirestore.instance
          .collection('docter')
          .doc(widget.doctorId)
          .collection('education');

      QuerySnapshot querySnapshot =
          await educationRef.orderBy('year', descending: true).get();

      return querySnapshot.docs
          .map((doc) => Education.fromFirestore(doc))
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IndexedStack(
        index: selectedIndex,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.stethoscope,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(specialist,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.suitcase,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('$experience years',
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('Rp $price',
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.mapLocation,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Education',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                ),
              ),
              FutureBuilder<List<Education>>(
                future: fetchEducation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No education data found.'));
                  } else {
                    List<Education> educationList = snapshot.data!;
                    return Column(
                      children: educationList.map((education) {
                        return Column(
                            children:
                                List.generate(education.year.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  education.year[index],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold),
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
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.visible,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        education.university[index],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey, fontFamily: 'Outfit'),
                                        overflow: TextOverflow.visible,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }));
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
          review(),
        ],
      ),
    );
  }

  Widget review() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Text('Review dokter'),
    );
  }
}

class Education {
  final List<String> year;
  final List<String> university;
  final List<String> pendidikan;

  Education({
    required this.year,
    required this.university,
    required this.pendidikan,
  });

  factory Education.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Education(
      year: (data['year'] as String).split(';'),
      university: (data['university'] as String).split(';'),
      pendidikan: (data['pendidikan'] as String).split(';'),
    );
  }
}
