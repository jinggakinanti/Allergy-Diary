// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/LoginOrRegis.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User is not logged in.";
        });
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          isLoading = false;
          print(user!.uid);
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "User data not found.";
          print(user!.uid);
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching user data: $e";
      });
      print("Error fetching user data: $e");
    }
  }

  int calculateAge(String birthDateString) {
    DateTime now = DateTime.now();
    DateTime dob = DateTime.parse(birthDateString);
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(newData);
      print("Data updated successfully");
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  void updateUserDataInFirebase(String field, String newValue) {
    if (field == 'age') {
      // Konversi umur menjadi tanggal lahir
      DateTime now = DateTime.now();
      DateTime dob = now.subtract(Duration(days: int.parse(newValue) * 365));
      newValue =
          dob.toIso8601String().substring(0, 10); // Format tanggal YYYY-MM-DD
    }
    Map<String, dynamic> updatedData = {field: newValue};
    updateUserData(user!.uid, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrRegister()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout)),
            ]),
        body: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Text(errorMessage!)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.account_circle_sharp,
                                size: 150,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Nama', style: TextStyle(fontFamily: 'Outfit')),
                          dataBox('name', userData?['name'] as String),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Umur', style: TextStyle(fontFamily: 'Outfit')),
                          dataAgeBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Nomor Telepon', style: TextStyle(fontFamily: 'Outfit')),
                          dataBox('phoneNumber',
                              userData?['phoneNumber'] as String),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Email', style: TextStyle(fontFamily: 'Outfit')),
                          dataBox('email', userData?['email'] as String),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Alamat', style: TextStyle(fontFamily: 'Outfit')),
                          dataBox('alamat', userData?['alamat'] as String),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Alergi', style: TextStyle(fontFamily: 'Outfit')),
                          dataBox('alergi', userData?['alergi'] as String),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('FAQ', style: TextStyle(fontFamily: 'Outfit')),
                          const Text('Bantuan', style: TextStyle(fontFamily: 'Outfit')),
                        ],
                      ),
                    ),
        ));
  }

  Widget dataBox(String data, String userData) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit $data', style: const TextStyle(fontFamily: 'Outfit')),
              content: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(hintText: 'Enter new $data', hintStyle: const TextStyle(fontFamily: 'Outfit')),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save', style: TextStyle(fontFamily: 'Outfit')),
                  onPressed: () {
                    updateUserDataInFirebase(data, _textEditingController.text);
                    Navigator.of(context).pop();
                    setState(() {
                      fetchUserData();
                      _textEditingController.clear();
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: const Color.fromRGBO(243, 246, 250, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userData,
                style: const TextStyle(fontSize: 16, fontFamily: 'Outfit'),
              ),
              const Text(
                'edit',
                style: TextStyle(color: Colors.grey, fontFamily: 'Outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataAgeBox() {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String newBirthDate = pickedDate.toIso8601String().substring(0, 10);
          updateUserDataInFirebase('birthDate', newBirthDate);
          setState(() {
            fetchUserData();
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: const Color.fromRGBO(243, 246, 250, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                calculateAge(userData!['birthDate']).toString(),
                style: const TextStyle(fontSize: 16, fontFamily: 'Outfit'),
              ),
              const Text(
                'edit',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
