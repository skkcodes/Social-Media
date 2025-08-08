import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/features/message.dart';
import 'package:imagi_go_ai/model/user_model.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/message_item.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final searchUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: "Messages", fontSize: 30, bold: true),
      ),
      body: Consumer<UserProvider>(
        builder: (ctx, userProvider, child) {
          final user = userProvider.user;
          if( user == null){
            return MyProgressIndicator();
          }
          final following = user.following;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                
                SizedBox(height: 10),
                MyTextField(
                  hintText: "",
                  icon: Icon(Icons.search),
                  label: "Search here",
                  onChanged: (value){
                    setState(() {
                      
                    });
                  },
                ),

                

                

                Expanded(
                  child: ListView.builder(
                    itemCount: following.length,
                    itemBuilder: (context, index) {
                      final uid = following[index];

                      return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>
                      >(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return ListTile(title: Text("User not found"));
                          }

                          final data = snapshot.data!.data()!;
                          if (searchUser.text.isEmpty) {
                            final list = [user.uid,data['uid']];
                            list.sort();
                            final chatId = "${list[0]}:${list[1]}";
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("chats").doc(chatId).collection('messages').orderBy('timestamp',descending: true).limit(1).snapshots(),
                              builder: (context,AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                                String text = "";
                                Timestamp time = Timestamp.now();
                                if (asyncSnapshot.connectionState == ConnectionState.waiting){
                                  return MyProgressIndicator();
                                }
                                if(asyncSnapshot.hasData && asyncSnapshot.data!.docs.isNotEmpty){
                                  final message = (asyncSnapshot.data!.docs)[0];
                                  text = message["text"];
                                  time = message['timestamp'];
                                  
                                  

                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Message(
                                      targetUser: data['uid'],
                                      targetImgUrl: data["imgUrl"],
                                      targetUserName: data['name'],
                                      currUser: user.uid
                                    )));
                                  },
                                  child: MessageItem(
                                    imgUrl: data['imgUrl'],
                                    senderName: data["name"],
                                    message: text,
                                    time:time ,
                                    
                                  ),
                                );
                              }
                            );
                          } else if (data['name'].toString().contains(
                            searchUser.text,
                          )) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Message(
                                  targetUser: data['uid'],
                                  targetImgUrl: data["imgUrl"],
                                  targetUserName: data['name'],
                                  currUser: user.uid
                                  
                                  
                                )));
                              },
                              child: MessageItem(
                                imgUrl: data['imgUrl'],
                                senderName: data["name"],
                                message: "",
                                time: Timestamp.now(),
                              ),
                            );
                          } else {
                            return MyText(text: "Not found");
                          }
                        },
                      );
                    },
                  ),
                ),
              
              ],
            ),
          );
        },
      ),
    );
  }
}
