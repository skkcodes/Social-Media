import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imagi_go_ai/auth/signin.dart';
import 'package:imagi_go_ai/features/edit_profile.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final database = FirebaseFirestore.instance.collection("posts").snapshots();

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF6C63FF);

    return FutureBuilder(
      future: Provider.of<UserProvider>(context).fetchUser(),
      builder: (context, asyncSnapshot) {
        return Consumer<UserProvider>(
          builder: (ctx, userProvider, child) {
            final user = Provider.of<UserProvider>(ctx, listen: true).user;
            if( user == null){
            return MyProgressIndicator();
          }
            String currImgUrl = user.imgUrl;

            

            var followers = user.followers.length;
            var following = user.following.length;
            var posts = user.posts.length;

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "@${user.username}",
                        style: GoogleFonts.poppins(
                          color: accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    /// Profile row
                    Row(
                      children: [
                        /// Avatar with glow
                        StoryItem(
                          imageUrl: currImgUrl,
                          userName: "",
                          radius: 35,
                        ),
                        const SizedBox(width: 20),

                        /// Posts, Followers, Following
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(label: 'Posts', value: "$posts"),
                              _StatItem(
                                label: 'Followers',
                                value: "$followers",
                              ),
                              _StatItem(
                                label: 'Following',
                                value: '$following',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Name and Bio
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(text: user.name,bold: true,fontSize: 16,),
                          MyText(text: user.bio,fontSize: 14,),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ), // Rounded corners
                              ),
                            ),
                            child: MyText(text: "Edit Profile", bold: true),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((onValue) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signin(),
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ), // Rounded corners
                              ),
                            ),
                            child: MyText(text: "Logout", bold: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(text: "Posts", bold: true),
                        Container(),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Grid of posts
                    StreamBuilder<QuerySnapshot>(
                      stream: database,
                      builder:
                          (
                            context,
                            AsyncSnapshot<QuerySnapshot> asyncSnapshot,
                          ) {
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return MyProgressIndicator();
                            }
                            if (asyncSnapshot.hasError) {
                              return MyText(text:  "Something wrong!");
                            }
                            if (!asyncSnapshot.hasData) {
                              return MyText(text: "Create a post.");
                            }
                            final userPosts = asyncSnapshot.data!.docs
                                .where((doc) => user.posts.contains(doc.id))
                                .toList();

                            return Expanded(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: user.posts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                    ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      onPostClick(
                                        userPosts[index]["postId"],
                                        userPosts[index]["imgUrl"],
                                        userPosts[index]["title"],
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            userPosts[index]["imgUrl"],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> onPostClick(String postId, String imgUrl, String title) async {
    final titleController = TextEditingController();
    titleController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: MyText(text: title),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );
                      var user = provider.user;
                      user!.posts.remove(postId);
                      provider.updateUser(user);

                      FirebaseStorage.instance.refFromURL(imgUrl).delete().then(
                        (onValue) {
                          FirebaseFirestore.instance
                              .collection("posts")
                              .doc(postId)
                              .delete()
                              .then((onValue) {
                                Navigator.pop(context);
                              });
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 14, 14),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Rounded corners
                      ),
                    ),
                    child: MyText(text: "Delete", bold: true),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(postId)
                          .update({"title": titleController.text})
                          .then((onValue) {
                            notify(context, "Post updated");
                            Navigator.pop(context);
                          })
                          .catchError((e) {
                            notify(context, e.toString());
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Rounded corners
                      ),
                    ),
                    child: MyText(text: "Update", bold: true),
                  ),
                ),
              ],
            ),
          ],
          content: SizedBox(
            height: 400,
            width: 400,
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: 450,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                MyTextField(
                  hintText: "",
                  icon: Icon(Icons.abc),
                  label: "Caption",
                  controller: titleController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Reusable widget for Posts, Followers, Following
class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({ required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(text: value,fontSize: 16,),
        MyText(text: label,fontSize: 14,),
      ],
    );
  }
}
