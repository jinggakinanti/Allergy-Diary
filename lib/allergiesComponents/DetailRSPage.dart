// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/allergiesComponents/DetailPaketPage.dart';

class DetailRSPage extends StatefulWidget {
  final String image;
  final String hospitalName;
  final String about;
  final String hospitalAddress;
  final String email;
  final String telepon;
  final String website;
  const DetailRSPage(
      {super.key,
      required this.image,
      required this.hospitalName,
      required this.about,
      required this.hospitalAddress,
      required this.email,
      required this.telepon,
      required this.website});

  @override
  State<DetailRSPage> createState() => _DetailRSPageState();
}

class _DetailRSPageState extends State<DetailRSPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hospital Details',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25,),
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
              Image.network(
                widget.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.hospitalName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'About',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isExpanded
                          ? widget.about
                          : '${widget.about.substring(0, 100)}...',
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Outfit'),
                    ),
                    TextSpan(
                      text:
                          isExpanded ? '   See Less' : '   See All',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(63, 142, 233, 100),
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Address',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: Text(widget.hospitalAddress, style: const TextStyle(fontFamily: 'Outfit'),))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Contact',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.email, style: const TextStyle(fontFamily: 'Outfit'),),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.telepon, style: const TextStyle(fontFamily: 'Outfit'),),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.globe,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.website, style: const TextStyle(fontFamily: 'Outfit'),)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPaketPage(hospitalName: widget.hospitalName,),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Order an Allergy Check',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
