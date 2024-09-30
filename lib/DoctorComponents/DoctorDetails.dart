// ignore_for_file: file_names, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorDetails extends StatefulWidget {
  final String specialist;
  final String experience;
  final String price;
  final String location;
  final String education;

  const DoctorDetails(
      {super.key,
      required this.specialist,
      required this.experience,
      required this.price,
      required this.location,
      required this.education});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Column(
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedIndex == 0)
                    Container(
                      height: 2,
                      width: 50,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Column(
                children: [
                  const Text(
                    'Review',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedIndex == 1)
                    Container(
                      height: 2,
                      width: 50,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ],
        ),
        about(),
      ],
    );
  }

  Widget about() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IndexedStack(
        index: selectedIndex,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.stethoscope,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('${widget.specialist}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.suitcase,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('${widget.experience} years',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('Rp ${widget.price}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.mapLocation,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Text(
                      '${widget.location}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Text(
                    'Education',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          review(),
        ],
      ),
    );
  }

  Widget review() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Text('Review dokter'),
    );
  }
}
