// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/MedicineComponents/PembayaranSelesai.dart';

class Pembayaran extends StatelessWidget {
  final String price;
  final String choosenMethod;
  const Pembayaran({super.key, required this.price, required this.choosenMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
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
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          'Virtual Account Numbers',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade600, fontFamily: 'Outfit'),
                        ),
                        Divider(
                          color: Colors.grey.shade600,
                          height: 1,
                          endIndent: 70,
                          indent: 70,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '1234567890123456789',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Outfit'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Payment ID',
                      style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Outfit'),
                    ),
                    const Text(
                      'IDKNSLN123456789',
                      style: TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Total Payment',
                      style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Outfit'),
                    ),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Payment Method',
                      style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Outfit'),
                    ),
                    Text(
                      choosenMethod,
                      style: const TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Time Limit',
                      style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Outfit'),
                    ),
                    const Text(
                      '23 Hours 59 Minutes 59 Seconds',
                      style: TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PembayaranSelesai()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
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
