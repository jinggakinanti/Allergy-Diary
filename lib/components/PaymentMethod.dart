// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  final String price;
  final Function(String, String) onPaymentMethodSelected;

  const PaymentMethod({
    super.key,
    required this.price,
    required this.onPaymentMethodSelected,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? selectedEWallet;

  @override
  Widget build(BuildContext context) {
    String finalPrice = widget.price;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Payment',
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
                  ),
                  Text('Rp $finalPrice',
                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 20)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Virtual Account',
                            style: TextStyle(fontFamily: 'Outfit', fontSize: 17)),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onPaymentMethodSelected(
                                'Virtual Account', 'image/BCA.png');
                            Navigator.of(context).pop();
                          },
                          child: buildPaymentOptions('image/BCA.png'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildEwalletDropdown(),
                      ],
                    ),
                  )),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  if (selectedEWallet != null) {
                    widget.onPaymentMethodSelected(
                        selectedEWallet!, getEwalletImage(selectedEWallet!));
                    Navigator.of(context).pop();
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
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 17,
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

  Widget buildPaymentOptions(String image) {
    return Row(
      children: [
        Image.asset(
          image,
          width: 80,
        ),
      ],
    );
  }

  Widget buildEwalletDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'E-Wallet',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 17),
        ),
        DropdownButton<String>(
          value: selectedEWallet,
          hint: const Text('Select E-Wallet'),
          items: [
            DropdownMenuItem(
              value: 'GoPay',
              child: _buildDropdownItem('image/gopay.png', 'GoPay'),
            ),
            DropdownMenuItem(
              value: 'OVO',
              child: _buildDropdownItem('image/ovo.png', 'OVO'),
            ),
            DropdownMenuItem(
              value: 'ShopeePay',
              child: _buildDropdownItem('image/shopeePay.png', 'ShopeePay'),
            ),
            DropdownMenuItem(
              value: 'DANA',
              child: _buildDropdownItem('image/dana.png', 'DANA'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedEWallet = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdownItem(String imagePath, String name) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Text(name),
      ],
    );
  }

  String getEwalletImage(String eWallet) {
    switch (eWallet) {
      case 'GoPay':
        return 'image/gopay.png';
      case 'OVO':
        return 'image/ovo.png';
      case 'ShopeePay':
        return 'image/shopeePay.png';
      case 'DANA':
        return 'image/dana.png';
      default:
        return '';
    }
  }
}
