import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';
import 'package:intl/intl.dart';

class PostItem extends StatelessWidget {
  final String postId;
  final String currUser;
  final String username;
  final String userTag;
  final String userImage;
  final String postImage;
  final String caption;
  final Timestamp timeAgo;

  const PostItem({
    super.key,
    required this.username,
    required this.userTag,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.timeAgo,
    required this.postId,
    required this.currUser,
  });



String formatChatTimestamp(Timestamp timestamp) {
  final DateTime time = timestamp.toDate();
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime messageDay = DateTime(time.year, time.month, time.day);

  if (messageDay == today) {
    return "Today";
  } else if (messageDay == today.subtract(const Duration(days: 1))) {
    return "Yesterday";
  } else if (now.difference(messageDay).inDays < 7) {
    return DateFormat.EEEE().format(time); // Full day name: e.g., "Tuesday"
  } else if (now.year == time.year) {
    return DateFormat.MMMd().format(time); // e.g., Jul 8
  } else {
    return DateFormat.yMMMd().format(time); // e.g., Jul 8, 2024
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("posts").doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final postData = snapshot.data!.data() as Map<String, dynamic>;
        final List likes = List.from(postData['likes'] ?? []);
        final List comments = List.from(postData['comments'] ?? []);

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black87 : Colors.grey.shade300,
                offset: const Offset(4, 4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: isDark ? const Color.fromARGB(255, 20, 4, 40) : const Color.fromARGB(255, 229, 218, 245),
                offset: const Offset(1, 1),
                blurRadius: 6,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  StoryItem(imageUrl: userImage, userName: "",radius: 25,),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: GoogleFonts.poppins(
                          color:Theme.of(context).textTheme.bodySmall?.color ,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                        MyText(text: userTag,fontSize: 12, ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_vert, color: theme.iconTheme.color),
                ],
              ),

              const SizedBox(height: 16),

              // POST IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(postImage, fit: BoxFit.cover),
              ),

              const SizedBox(height: 12),

              // ACTIONS
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      final postRef = FirebaseFirestore.instance.collection("posts").doc(postId);
                      if (likes.contains(currUser)) {
                        postRef.update({
                          'likes': FieldValue.arrayRemove([currUser])
                        });
                      } else {
                        postRef.update({
                          'likes': FieldValue.arrayUnion([currUser])
                        });
                      }
                    },
                    child: Icon(
                      likes.contains(currUser) ? Icons.favorite : Icons.favorite_border,
                      color: likes.contains(currUser) ? Colors.pink : theme.iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(likes.length.toString(), style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap:() => showCommentDialog(context,postId,comments),
                    child: Icon(Icons.comment, color: theme.iconTheme.color)),
                  const SizedBox(width: 6),
                  Text(comments.length.toString(), style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  MyText(text:  formatChatTimestamp(timeAgo),fontSize: 12,),
                ],
              ),

              const SizedBox(height: 10),

              // CAPTION
              Text(caption, style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodySmall?.color)),
            ],
          ),
        );
      },
    );

  }
  Future<void> showCommentDialog(BuildContext context, String postId, List comments) async {
  final TextEditingController commentController = TextEditingController();
  final theme = Theme.of(context);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75, // 75% of screen height
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
    16,
    16,
    16,
    MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              children: [
                const MyText(text: "Comments", fontSize: 22, bold: true),
                const SizedBox(height: 10),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(child: MyText(text: "No comments yet"))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index] as Map<String, dynamic>;
                            

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("users").snapshots(),
                              builder: (context,AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                                if (asyncSnapshot.connectionState == ConnectionState.waiting){
                                  return MyProgressIndicator();
                                }
                                if(!asyncSnapshot.hasData){
                                  return MyText(text: "No comments");
                                }
                                if(asyncSnapshot.hasError){
                                  return MyText(text: "Something wrong!");
                                }
                                
                                final docs = asyncSnapshot.data!.docs ;
                                final userDoc = docs.firstWhere(
                                  (doc)=> doc.id == comment["uid"],
                                  
                                );


                                final userData = userDoc.data() as Map<String,dynamic>;
                                return Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Icon(Icons.comment),
                                    title: MyText(
                                      text: comment['text'] ?? '',
                                      fontSize: 16,
                                    ),
                                    subtitle: comment['uid'] != null
                                        ? MyText(text: 'by ${userData['name']}', fontSize: 12)
                                        : null,
                                  ),
                                );
                              }
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                MyTextField(
                  controller: commentController,
                  hintText: "",
                  icon: const Icon(Icons.comment),
                  label: "Write something here...",
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () async {
                    final commentText = commentController.text.trim();
                    if (commentText.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("posts")
                          .doc(postId)
                          .update({
                        "comments": FieldValue.arrayUnion([
                          {
                            "uid": FirebaseAuth.instance.currentUser!.uid,
                            "text": commentText,
                            "timestamp": Timestamp.now(),
                          }
                        ])
                      });
                      Navigator.of(context).pop(); // Close bottom sheet
                    }
                  },
                  child: const MyText(text: "Post Comment", bold: true),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}
