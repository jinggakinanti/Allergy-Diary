// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  final List<String> detectedAllergens;
  final List<String> userAllergies;

  const ResultScreen({
    super.key,
    required this.text,
    required this.detectedAllergens,
    required this.userAllergies,
  });

  @override
  Widget build(BuildContext context) {
    bool allergensDetected = detectedAllergens
        .any((allergen) => userAllergies.contains(allergen));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Komposisi',
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
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: allergensDetected ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(
                      allergensDetected ? Icons.error : Icons.check_circle,
                      color: allergensDetected ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        allergensDetected
                            ? 'Produk ini tidak cocok dengan kebutuhanmu'
                            : 'Produk ini cocok dengan kebutuhanmu',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Komposisi Makanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: text.split(', ').map((ingredient) {
                  bool isTrigger = detectedAllergens.any((allergen) {
                    // Check if the ingredient is a detected allergen or its trigger
                    return ingredient.toLowerCase().contains(allergen.toLowerCase());
                  });
                  print('Ingredient: $ingredient');
                  print('Is Trigger: $isTrigger');
                  return Text(
                    '$ingredient, ',
                    style: TextStyle(
                      fontSize: 15,
                      color: isTrigger ? Colors.red : Colors.black,
                      fontFamily: 'Outfit',
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Detected Allergens',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Outfit',
                ),
              ),
              ...detectedAllergens.map(
                (allergen) => Text(
                  allergen,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
