// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/ChatComponents/chatBubble.dart';
import 'package:project/ChatComponents/chatService.dart';

class DoctorChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const DoctorChatPage(
      {super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  final TextEditingController messageController = TextEditingController();
  final chatService cs = chatService();
  final FocusNode myFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), scrollDown);
      }
    });
    Future.delayed(const Duration(milliseconds: 100), scrollDown);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await cs.sendMessage(widget.receiverId, messageController.text);
      print(widget.receiverId);
      messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 250, 1),
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [Expanded(child: buildMessageList()), buildUserInput()],
      ),
    );
  }

  Widget buildMessageList() {
    String senderID = getCurrentUser()!.uid;
    return StreamBuilder(
        stream: cs.getMessages(widget.receiverId, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error", style: TextStyle(fontFamily: 'Outfit'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading .. ", style: TextStyle(fontFamily: 'Outfit'));
          }

          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: myFocusNode,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                fillColor: Color.fromRGBO(243, 246, 250, 1),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                hintText: 'Enter your message...',
                hintStyle: TextStyle(fontFamily: 'Outfit')
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(71, 116, 186, 1),
            ),
            child: GestureDetector(
              onTap: sendMessage,
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Send',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
