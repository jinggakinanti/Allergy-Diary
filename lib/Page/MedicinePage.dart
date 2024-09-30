// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/MedicineComponents/DetailPembayaran.dart';
import 'package:project/readData/GetMedicineInfo.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  List<String> docIDs = [];
  final searchController = TextEditingController();

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('medicine')
        .get()
        .then((snapshot) => snapshot.docs.forEach((medicine) {
              print(medicine.reference);
              docIDs.add(medicine.reference.id);
            }));
  }

  void showMedicineDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Text(
                    data['medicineName'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (data.containsKey('image'))
                  Image.network('${data['image']}'),
                const SizedBox(height: 10),
                Text('Rp: ${data['price']}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Outfit',
                        color: Color.fromRGBO(63, 142, 233, 1),
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  'Description',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${data['description']}', style: const TextStyle(fontFamily: 'Outfit'),),
                    )),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPembayaran(product: data['medicineName'], price: data['price'])));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'Medicine',
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
                          'Medicine Recommendation',
                          style: TextStyle(fontSize: 25, fontFamily: 'Outfit'),
                        ),
                        Text(
                          'Find the medicine for your allergies here!',
                          style: TextStyle(
                              fontSize: 16.5,
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
                            prefixIcon: const Icon(Icons.search),
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
                            hintText: 'Search for Medicine',
                            hintStyle: TextStyle(fontFamily: 'Outfit', color: Colors.grey.shade400),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                              child: MedicineInfo(
                                documentId: docIDs[firstIndex],
                                onTap: showMedicineDetails,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 100,
                            ),
                            if (secondIndex < docIDs.length)
                              Expanded(
                                child: MedicineInfo(
                                  documentId: docIDs[secondIndex],
                                  onTap: showMedicineDetails,
                                ),
                              ),
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
