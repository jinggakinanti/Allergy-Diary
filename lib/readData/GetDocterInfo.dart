// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DocterInfo extends StatelessWidget {
  final String documentId;
  final Function(String, Map<String, dynamic>) onTap;
  const DocterInfo({super.key, required this.documentId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    CollectionReference docter =
        FirebaseFirestore.instance.collection('docter');

    return FutureBuilder<DocumentSnapshot>(
      future: docter.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return GestureDetector(
              onTap: () => onTap(documentId, data), child: buildMedicineContainer(data));
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget buildMedicineContainer(Map<String, dynamic> data) {
    return Container(
        width: 175,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const SizedBox(height: 100,),
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color.fromARGB(255, 149, 205, 251),
                        child: Image.network('${data['image']}'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${data['name']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit'
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.stethoscope,
                            size: 15,
                            color: Color.fromRGBO(71, 116, 186, 1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${data['specialist']}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(71, 116, 186, 1)))
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
                            color: Color.fromRGBO(71, 116, 186, 1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${data['experience']} years',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(71, 116, 186, 1)))
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
                            color: Color.fromRGBO(71, 116, 186, 1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${data['price']}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(71, 116, 186, 1)))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
