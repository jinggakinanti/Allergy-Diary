// ignore_for_file: file_names, avoid_print, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/DoctorComponents/DoctorProfile.dart';
import 'package:project/readData/GetDocterInfo.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<String> docIDs = [];
  final searchController = TextEditingController();

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('docter')
        .get()
        .then((snapshot) => snapshot.docs.forEach((docter) {
              docIDs.add(docter.reference.id);
            }));
  }

  void doctorProfile(String doctorId, Map<String, dynamic> data) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorProfile(
            imagePath: '${data['image']}',
            name: '${data['name']}',
            specialist: '${data['specialist']}',
            experience: '${data['experience']}',
            price: '${data['price']}',
            location: '${data['location']}',
            doctorId: doctorId,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'Consultation',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: FutureBuilder(
          future: getDocId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                itemCount: (docIDs.length / 2).ceil() + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'List of Docters',
                          style: TextStyle(fontSize: 25, fontFamily: 'Outfit'),
                        ),
                        Text(
                          'Consultation with selected medical experts Alergy Diary',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Outfit',
                              color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else if (index == 1) {
                    return Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  } else {
                    int firstIndex = (index - 2) * 2;
                    int secondIndex = firstIndex + 1;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DocterInfo(
                                documentId: docIDs[firstIndex],
                                onTap: doctorProfile,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            if (secondIndex < docIDs.length)
                              Expanded(
                                child: DocterInfo(
                                  documentId: docIDs[secondIndex],
                                  onTap: doctorProfile,
                                ),
                              ),
                            const SizedBox(
                              height: 260,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
