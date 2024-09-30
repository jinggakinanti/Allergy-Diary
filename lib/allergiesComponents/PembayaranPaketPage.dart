// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/MedicineComponents/Pembayaran.dart';
import 'package:project/components/PaymentMethod.dart';

class PembayaranPaketPage extends StatefulWidget {
  final String paket;
  final String harga;
  final String hospitalName;
  final String choosenDate;

  const PembayaranPaketPage({
    super.key,
    required this.paket,
    required this.harga,
    required this.hospitalName,
    required this.choosenDate,
  });

  @override
  State<PembayaranPaketPage> createState() => _PembayaranPaketPageState();
}

class _PembayaranPaketPageState extends State<PembayaranPaketPage> {
  String? selectedPaymentMethod;
  String? selectedPaymentImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Allergy Check ${widget.paket}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(height: 10),
              Text(
                widget.hospitalName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(height: 10),
              Text(
                widget.choosenDate,
                style: const TextStyle(color: Colors.grey, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID Pembayaran',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Outfit'),
                  ),
                  Text('IDKNSLN123456789', style: TextStyle(fontFamily: 'Outfit'),),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Uji Sertifikasi',
                      style: TextStyle(color: Colors.grey, fontFamily: 'Outfit')),
                  Text('Rp ${widget.harga}', style: const TextStyle(fontFamily: 'Outfit'),),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(height: 20),
              if (selectedPaymentMethod != null && selectedPaymentImage != null)
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Payment Method',
                            style: TextStyle(fontSize: 17, fontFamily: 'Outfit'),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                selectedPaymentImage!,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedPaymentMethod!,
                                style: const TextStyle(fontSize: 17, fontFamily: 'Outfit'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethod(
                        price: widget.harga,
                        onPaymentMethodSelected:
                            (String paymentMethod, String paymentImage) {
                          setState(() {
                            selectedPaymentMethod = paymentMethod;
                            selectedPaymentImage = paymentImage;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromRGBO(143, 174, 222, 1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.wallet,
                            size: 17,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Choose Payment Method',
                            style: TextStyle(fontSize: 15, fontFamily: 'Outfit'),
                          ),
                        ],
                      ),
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (selectedPaymentMethod == null &&
                      selectedPaymentImage == null) {
                    showErrorPopup(context,'Payment Method not Chosen', 'Please Select the Payment Method');
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pembayaran(price: widget.harga, choosenMethod: selectedPaymentMethod!,)
                        ));
                  }
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
                        fontSize: 16,
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

  void showErrorPopup(BuildContext context, String error, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error, style: const TextStyle(fontFamily: 'Outfit'),),
          content: Text(errorMessage, style: const TextStyle(fontFamily: 'Outfit'),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontFamily: 'Outfit')),
            ),
          ],
        );
      },
    );
  }
}
