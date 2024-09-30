// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineInfo extends StatelessWidget {
  final String documentId;
  final Function(Map<String, dynamic>) onTap;

  const MedicineInfo(
      {super.key, required this.documentId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    CollectionReference medicine =
        FirebaseFirestore.instance.collection('medicine');

    return FutureBuilder<DocumentSnapshot>(
      future: medicine.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return GestureDetector(
              onTap: () => onTap(data), child: buildMedicineContainer(data));
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget buildMedicineContainer(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      height: 220,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: data.containsKey('image')
                  ? Image.network('${data['image']}')
                  : Container(),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${data['medicineName']}',
              style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Rp: ${data['price']}',
              style: const TextStyle(fontFamily: 'Outfit', color: Color.fromRGBO(63, 142, 233, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
