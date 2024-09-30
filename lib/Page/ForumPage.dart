// ignore_for_file: camel_case_types, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/ForumComponents/AddForum.dart';
import 'package:project/ForumComponents/ForumInfo.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.grey.shade200,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintText: 'Search for Forum...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Outfit'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('forums').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final forums = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: forums.length,
                    itemBuilder: (context, index) {
                      var forum = forums[index];
                      Timestamp timestamp = forum['timestamp'];
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumInfoPage(forum: forum,),
                              ));
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(forum['name'], style: const TextStyle(fontFamily: 'Outfit'),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(formattedDate,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12, fontFamily: 'Outfit')),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(forum['content'], style: const TextStyle(fontFamily: 'Outfit'),)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(FontAwesomeIcons.heart,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(forum['likes'].toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.mode_comment_outlined,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(forum['repliesCount'] != null ? forum['repliesCount'].toString() : '0')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddForumPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget forumInfo(
      String name, String date, String content, int like, int comments) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(content)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.heart, size: 20),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(like.toString()),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.mode_comment_outlined, size: 20),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(comments.toString()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
