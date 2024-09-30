// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/allergiesComponents/PembayaranPaketPage.dart';

class CekAlergiSchedule extends StatefulWidget {
  final String choosenPaket;
  final String harga;
  final String hospital;
  const CekAlergiSchedule(
      {super.key,
      required this.choosenPaket,
      required this.harga,
      required this.hospital});

  @override
  State<CekAlergiSchedule> createState() => _CekAlergiScheduleState();
}

class _CekAlergiScheduleState extends State<CekAlergiSchedule> {
  int selectedDateIndex = 0;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;
  String? customDate;

  List<String> date = [];

  final List<String> time = [
    '08:00 WIB',
    '10:00 WIB',
    '12:00 WIB',
    '14:00 WIB',
    '16:00 WIB',
    '18:00 WIB',
    '20:00 WIB',
    '22:00 WIB',
  ];

  @override
  void initState() {
    super.initState();
    initializeDate();
  }

  void initializeDate() {
    final DateTime today = DateTime.now();
    date = List.generate(3, (index) {
      final DateTime date = today.add(Duration(days: index));
      return DateFormat('EEE\ndd\nMMM yyyy').format(date);
    });
    date.add('Others');
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2026));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        customDate = DateFormat('EEE\ndd\nMMMM yyyy').format(selectedDate!);
        selectedDateIndex = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Schedule',
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
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Select Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(date.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (index == 3) {
                          selectDate(context);
                        } else {
                          selectedDateIndex = index;
                          customDate = null;
                        }
                      });
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedDateIndex == index
                            ? Colors.blue
                            : Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(children: [
                        if (index < date.length &&
                            date[index].split('\n').length > 2) ...[
                          text(date[index].split('\n')[0], index),
                          text(date[index].split('\n')[1], index),
                          text(date[index].split('\n')[2], index),
                        ] else if (index == 3 && customDate == null) ...[
                          const Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 24,
                              ),
                              SizedBox(height: 35),
                              Text(
                                'Others',
                                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                              )
                            ],
                          )
                        ] else if (index == 3 && customDate != null) ...[
                          text(customDate!.split('\n')[0], index),
                          text(customDate!.split('\n')[1], index),
                          text(customDate!.split('\n')[2], index),
                        ],
                      ]),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text('Select Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(time.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedTimeIndex == index
                            ? Colors.blue
                            : Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                          color: selectedTimeIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (selectedDateIndex >= 0 &&
                      selectedDateIndex < date.length &&
                      selectedTimeIndex >= 0 &&
                      selectedTimeIndex < time.length) {
                    final selectedTime = time[selectedTimeIndex];

                    String customSelectedDate;
                    if (customDate != null) {
                      customSelectedDate = DateFormat('d MMMM yyyy').format(
                          DateFormat('EEE\ndd\nMMM').parse(customDate!));
                    } else {
                      customSelectedDate = DateFormat('d MMMM yyyy').format(
                          DateTime.now()
                              .add(Duration(days: selectedDateIndex)));
                    }
                    final choosenDate = "$customSelectedDate $selectedTime";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PembayaranPaketPage(
                                paket: widget.choosenPaket,
                                harga: widget.harga,
                                hospitalName: widget.hospital, choosenDate: choosenDate,)));
                  } else {
                    showErrorPopup(context, "Something Missing...", "Please select the Date/Time");
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ])));
  }

  Widget text(String date, int index) {
    return Text(
      date,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
        color: selectedDateIndex == index ? Colors.white : Colors.black,
      ),
    );
  }

  void showErrorPopup(BuildContext context, String error, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error, style: const TextStyle(fontFamily: 'Outfit'),),
          content: Text(errorMessage, style: const TextStyle(fontFamily: 'Outfit')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: 
              TextStyle(fontFamily: 'Outfit')),
            ),
          ],
        );
      },
    );
  }
}
