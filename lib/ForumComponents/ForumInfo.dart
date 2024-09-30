// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ForumInfoPage extends StatefulWidget {
  final DocumentSnapshot forum;
  const ForumInfoPage({super.key, required this.forum});

  @override
  State<ForumInfoPage> createState() => _ForumInfoPageState();
}

class _ForumInfoPageState extends State<ForumInfoPage> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference likeDocRef = FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.forum.id)
          .collection('likes')
          .doc(user.uid);

      DocumentSnapshot likeDoc = await likeDocRef.get();
      setState(() {
        _isLiked = likeDoc.exists;
      });
    }
  }

  Future<void> _addReply(String content) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      print('User Document Data: ${userDoc.data()}'); // Debug statement

      String username = (userDoc.data() as Map<String, dynamic>)['name'];

      DocumentReference forumDocRef =
          FirebaseFirestore.instance.collection('forums').doc(widget.forum.id);

      await forumDocRef.collection('replies').add({
        'content': content,
        'name': username,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await forumDocRef.update({
        'repliesCount': FieldValue.increment(1),
      });

      setState(() {
        _replyController.clear();
      });
    }
  }

  Future<void> _toggleLike() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference forumDocRef =
          FirebaseFirestore.instance.collection('forums').doc(widget.forum.id);
      DocumentReference likeDocRef =
          forumDocRef.collection('likes').doc(user.uid);

      if (_isLiked) {
        // Unlike the post
        await likeDocRef.delete();
        await forumDocRef.update({
          'likes': FieldValue.increment(-1),
        });
        setState(() {
          _isLiked = false;
        });
      } else {
        // Like the post
        await likeDocRef.set(<String, dynamic>{});
        await forumDocRef.update({
          'likes': FieldValue.increment(1),
        });
        setState(() {
          _isLiked = true;
        });
      }
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empty Replies', style: TextStyle(fontFamily: 'Outfit'),),
          content: const Text('Please fill in the reply before sending.', style: TextStyle(fontFamily: 'Outfit')),
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
    String formattedDate = '';
    if (widget.forum['timestamp'] != null) {
      Timestamp timestamp = widget.forum['timestamp'] as Timestamp;
      DateTime dateTime = timestamp.toDate();
      formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.forum['name'], style: const TextStyle(fontFamily: 'Outfit'),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Outfit')),
                ],
              ),
              leading: const CircleAvatar(
                child: Icon(
                  Icons.account_circle,
                  size: 40,
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(widget.forum['content'], style: const TextStyle(fontFamily: 'Outfit'))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Row(
                      children: [
                        Icon(
                          _isLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          size: 20,
                          color: _isLiked ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.forum['likes'].toString()),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.mode_comment_outlined, size: 20),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.forum['repliesCount'] != null
                          ? widget.forum['repliesCount'].toString()
                          : '0')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 20, thickness: 1),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('forums')
                    .doc(widget.forum.id)
                    .collection('replies')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No Replies.', style: TextStyle(fontFamily: 'Outfit'),);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var reply = snapshot.data!.docs[index];
                      Timestamp replyTimestamp = reply['timestamp'];
                      DateTime replyDateTime = replyTimestamp.toDate();
                      String replyFormattedDate =
                          DateFormat('dd MMM yyyy, hh:mm a')
                              .format(replyDateTime);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(reply['name'], style: const TextStyle(fontFamily: 'Outfit'),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(replyFormattedDate,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.account_circle,
                                size: 40,
                              ),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(reply['content'], style: const TextStyle(fontFamily: 'Outfit'),)),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Divider()),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 210,
                    height: 55,
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontFamily: 'Outfit'),
                        hintText: 'Enter a reply...',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromRGBO(143, 174, 222, 1)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_replyController.text.isEmpty) {
                          _showAlertDialog();
                        } else {
                          _addReply(_replyController.text).then((_) {
                            _replyController.clear();
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
            ),
          ],
        ),
      ),
    );
  }
}
