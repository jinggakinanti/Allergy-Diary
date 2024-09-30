// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddForumPage extends StatefulWidget {
  const AddForumPage({super.key});

  @override
  State<AddForumPage> createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final TextEditingController _contentController = TextEditingController();
  late Future<String?> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _fetchUsername();
  }

  Future<String?> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (document.exists) {
        return (document.data() as Map<String, dynamic>)['name'] as String?;
      }
    }
    return null;
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontFamily: 'Outfit')),
          content: Text(content, style: const TextStyle(fontFamily: 'Outfit')),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Unggah Forum',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Unggah Forum',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            body: const Center(child: Text('Failed to load username')),
          );
        }

        String? username = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Unggah Forum',
              style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromRGBO(143, 174, 222, 1)),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_contentController.text.isEmpty) {
                      _showAlertDialog('Empty Content', 'Please fill in the content before submitting.');
                    } else {
                      FirebaseFirestore.instance.collection('forums').add({
                        'content': _contentController.text,
                        'name': username,
                        'likes': 0,
                        'comments': 0,
                        'repliesCount': 0,
                        'timestamp': FieldValue.serverTimestamp(),
                      }).then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit'
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: 'Write your story here',
                      hintStyle: const TextStyle(fontFamily: 'Outfit'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.image, size: 30),
                      Icon(Icons.camera_alt, size: 30),
                      Icon(Icons.insert_emoticon, size: 30),
                      Icon(Icons.more_horiz, size: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
