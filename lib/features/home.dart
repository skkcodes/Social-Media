import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:imagi_go_ai/features/search.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/post_item.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context,listen: true).user;
    if(user== null){
      return Container();
    }
    final followings = user.following;
    int count = followings.length;
    return Scaffold(
          body: ListView(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: MyText(text: "ImagiGoAI", fontSize: 30, bold: true),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                        icon: const Icon(Icons.search_sharp, size: 35),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings_outlined, size: 30),
                      ),
                    ],
                  ),
                ],
              ),

              // Story Row
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: count + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StoryItem(
                          imageUrl: user.imgUrl,
                          userName: user.username,
                          isViewed: index == 0 || index == 3,
                        ),
                      );
                    }

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(followings[index - 1])
                          .snapshots(),

                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> userSnap) {
                            if (userSnap.connectionState ==
                                ConnectionState.waiting) {
                              return MyProgressIndicator();
                            }

                            if (!userSnap.hasData || !userSnap.data!.exists) {
                              return const SizedBox(); // or handle appropriately
                            }

                            final userData =
                                userSnap.data!.data() as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StoryItem(
                                imageUrl: userData['imgUrl'],
                                userName: userData['username'],
                                isViewed: index == 0 || index == 3,
                              ),
                            );
                          },
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Posts
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MyProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const MyText(text: "Something went wrong");
                  }

                  final posts = snapshot.data?.docs ?? [];

                  if (posts.isEmpty) {
                    return const Center(child: Text('No posts yet'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final postDoc = posts[index];
                      final post =
                          postDoc.data() as Map<String, dynamic>? ?? {};

                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(post['uid']?.toString())
                            .snapshots(),
                        builder: (context, userSnap) {
                          if (!userSnap.hasData) return const SizedBox.shrink();

                          final user =
                              userSnap.data!.data() as Map<String, dynamic>? ??
                              {};

                          return PostItem(
                            key: ValueKey(postDoc.id),
                            currUser: FirebaseAuth.instance.currentUser!.uid,
                            postId: postDoc.id,
                            username: user['name'] ?? 'Unknown',
                            userTag: '@${user['username'] ?? 'user'}',
                            userImage:
                                user['imgUrl'] ??
                                'https://i.pravatar.cc/150?img=0',
                            postImage: post['imgUrl'] ?? '',
                            caption: post['title'] ?? '',
                            timeAgo: post['createdAt'], // TODO: use timestamp
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      
  }
}
