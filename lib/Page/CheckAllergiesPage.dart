// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/allergiesComponents/RekomendasiRSPage.dart';

class CheckAllergiesPage extends StatefulWidget {
  const CheckAllergiesPage({super.key});

  @override
  State<CheckAllergiesPage> createState() => _CheckAllergiesPageState();
}

class _CheckAllergiesPageState extends State<CheckAllergiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allergy Check',
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
      body: const RekomendasiRSPage(),
    );
  }
}