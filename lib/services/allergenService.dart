// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AllergenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Allergen>> getAllergens() async {
    QuerySnapshot snapshot = await _firestore.collection('allergens').get();
    return snapshot.docs.map((doc) => Allergen.fromFirestore(doc)).toList();
  }
}

class Allergen {
  final String name;
  final List<String> triggers;

  Allergen({required this.name, required this.triggers});

  factory Allergen.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Allergen(
      name: data['name'] ?? '',
      triggers: List<String>.from(data['triggers'] ?? []),
    );
  }
}
