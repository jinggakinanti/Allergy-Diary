// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/ChatComponents/DetailChat.dart';
import 'package:project/ChatComponents/doctorChatPage.dart';
import 'package:project/ChatComponents/userTile.dart';
import 'package:project/ChatComponents/chatService.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final TextEditingController messageController = TextEditingController();
  final chatService cs = chatService();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Widget>(
        future: userOrDoctor(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return snapshot.data ?? Container();
        },
      ),
    );
  }

  Future<Widget> userOrDoctor(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;

    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String? userRole = userSnapshot['role'];

      if (userRole == 'docter') {
        return buildDocterList();
      } else {
        return buildUserList();
      }
    } else {
      return const Center(child: Text('User not authenticated', style: TextStyle(fontFamily: 'Outfit'),));
    }
  }

  Widget buildDocterList() {
    return StreamBuilder(
      stream: cs.getDoctorChatListStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error', style: TextStyle(fontFamily: 'Outfit'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...', style: TextStyle(fontFamily: 'Outfit'));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (doctorData) => buildDocterListItem(doctorData, context))
                .toList(),
          );
        } else {
          return const Center(child: Text('No patient available', style: TextStyle(fontFamily: 'Outfit')));
        }
      },
    );
  }

  Widget buildDocterListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final userName = userData['name'] ?? 'Unknown User';
    final userId = userData['uid'] ?? 'Unknown ID';
    print('User Data tee: $userData');

    return UserTile(
        text: userName,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorChatPage(
                  receiverEmail: userName,
                  receiverId: userId,
                ),
              ));
        });
  }

  Widget buildUserList() {
    return StreamBuilder(
      stream: cs.getBookedDoctorsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error', style: TextStyle(fontFamily: 'Outfit'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...', style: TextStyle(fontFamily: 'Outfit'));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (doctorData) => buildUserListItem(doctorData, context))
                .toList(),
          );
        } else {
          return const Center(child: Text('No booked doctors available', style: TextStyle(fontFamily: 'Outfit')));
        }
      },
    );
  }

  Widget buildUserListItem(
      Map<String, dynamic> doctorData, BuildContext context) {
    print('Doctor Data: $doctorData');

    final doctorName = doctorData['name'] ?? 'Unknown Doctor';
    final doctorId = doctorData['uid'] ?? 'Unknown ID';

    return UserTile(
      text: doctorName,
      onTap: () async {
        try {
          final canChat = await canUserChatWithDoctor(doctorId);
          if (canChat) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailChatPage(
                    receiverEmail: doctorData['name'],
                    receiverID: doctorData['uid'],
                  ),
                ));
          } else {
            showSchedulePopup(context);
          }
        } catch (e) {
          print('Error checking chat availability: $e');
          showErrorPopup(context, e.toString());
        }
      },
    );
  }

  Future<bool> canUserChatWithDoctor(String doctorId) async {
    try {
      final userId = getCurrentUser()!.uid;
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        final appointment = appointmentSnapshot.docs.first.data();
        final appointmentDate = appointment['date'];
        final appointmentTime = appointment['time'];

        final appointmentDateTime = DateFormat('EEE, dd MMM yyyy hh:mm')
            .parse('$appointmentDate $appointmentTime');

        print('Current time: ${DateTime.now()}');
        print('Appointment time: $appointmentDateTime');

        if (DateTime.now().isAfter(appointmentDateTime)) {
          print('User can chat');
          return true;
        } else {
          print('User cannot chat');
          return false;
        }
      } else {
        print('No appointment found');
        return false;
      }
    } catch (e) {
      print('Error in canUserChatWithDoctor: $e');
      rethrow;
    }
  }

  void showSchedulePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat Unavailable', style: TextStyle(fontFamily: 'Outfit')),
          content: const Text(
              'You can only chat with the doctor according to the selected schedule.', style: TextStyle(fontFamily: 'Outfit')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorPopup(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(fontFamily: 'Outfit')),
          content: Text(errorMessage, style: const TextStyle(fontFamily: 'Outfit')),
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
