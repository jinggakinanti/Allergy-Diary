// ignore_for_file: file_names, camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/components/Message.dart';

class chatService {
  final FirebaseFirestore ff = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return ff.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getBookedDoctorsStream() {
    final userId = auth.currentUser!.uid;
    return ff
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .snapshots()
        .map((snapshot) {
      print('Appointments snapshot: ${snapshot.docs}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Fetched doctor data: $data');
        return {
          'name': data['doctorName'] ?? 'Unknown Doctor',
          'uid': data['doctorId'] ?? 'Unknown ID',
          'date': data['date'] ?? 'Unknown Date',
          'time': data['time'] ?? 'Unknown Time',
        };
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getDoctorChatListStream() {
    final userId = auth.currentUser!.uid;
    return ff
        .collection('docter')
        .doc(userId)
        .collection('schedule')
        .snapshots()
        .map((snapshot) {
      print('Doctor appointments snapshot: ${snapshot.docs}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Fetched user data: $data');
        return {
          'name': data['name'] ?? 'Unknown User',
          'uid': data['userId'] ?? 'Unknown ID',
          'date': data['date'] ?? 'Unknown Date',
          'time': data['time'] ?? 'Unknown Time',
        };
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    print('Sending message to chat room: $chatRoomID');

    await ff
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    print('Fetching messages from chat room: $chatRoomID');

    return ff
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
