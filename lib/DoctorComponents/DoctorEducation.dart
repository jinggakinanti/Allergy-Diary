import 'package:flutter/material.dart';

class EducationItem extends StatelessWidget {
  final String educationData;

  const EducationItem({
    super.key,
    required this.educationData,
  });

  @override
  Widget build(BuildContext context) {
    // Split the educationData string
    List<String> dataParts = educationData.split(';');
    String year = dataParts[0];
    String pendidikan = dataParts[1];
    String university = dataParts[2];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(243, 246, 250, 1),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            pendidikan,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            university,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
