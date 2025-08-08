import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/message_bubble.dart';
import 'package:imagi_go_ai/widgets/message_item.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';

class Message extends StatelessWidget {
  final String targetUser ;
  final String targetImgUrl ;
  final String targetUserName ;
  final String currUser;
  Message({super.key,required this.targetUser, required this.targetImgUrl, required this.targetUserName, required this.currUser});
  
  final sendTxtEditingController=TextEditingController();
  final chats = FirebaseFirestore.instance.collection("chats");
  final ScrollController scrollController = ScrollController();
  
  


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ids = [currUser,targetUser]..sort();
    final chatId = "${ids[0]}:${ids[1]}";
    return Scaffold(
      
      body: Column(
        children: [
          SizedBox(height: 40),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                
                Row(
                  
                  children: [
                    StoryItem(
                      imageUrl:targetImgUrl,
                      userName: "",
                      radius: 20,
                    
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text: targetUserName,bold: true, fontSize: 20,),
                        MyText(text: "online",fontSize: 14,)
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      
                      decoration: BoxDecoration(
                        color: isDark?const Color.fromARGB(66, 106, 100, 100): const Color.fromARGB(255, 222, 223, 224),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      
                      child: Icon(Icons.call,size: 24,color: Colors.deepPurpleAccent,)),
                      SizedBox(width: 10,),
                    Container(
                      height: 40,
                      width: 40,
                      
                      decoration: BoxDecoration(
                        color: isDark?const Color.fromARGB(66, 106, 100, 100): const Color.fromARGB(255, 222, 223, 224),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Icon(Icons.video_call,size: 24,color: Colors.deepPurpleAccent,)),
                  ],
                )
              ],
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: chats.doc(chatId).collection('messages').orderBy('timestamp').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { 
              if (snapshot.connectionState == ConnectionState.waiting){
                return MyProgressIndicator();
              }
              if(!snapshot.hasData){
                return MyText(text: "No messages");
              }
              if(snapshot.hasError){
                return MyText(text: "Something wrong");
              }

              final messages = snapshot.data!.docs;
              if (messages.isEmpty){
                return Expanded(child: MyText(text: "No messages"));
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
             
             return Expanded(
              child: ListView.builder(
                reverse: false,
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                final message = messages[index];

                  if (message['reciver'] == currUser ){
                    chats.doc(chatId).collection('messages').doc(message.id).update({
                      'isSeen': true,
                    });

                  }

                  return MessageBubble(
                    text: message["text"],
                    isMe: message['sender']==currUser ,
                    timestamp: (message['timestamp'] as Timestamp).toDate()  ,
                    seenStatus: message['isSeen'],
                  );
                },
              ),
            );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:isDark?const Color.fromARGB(66, 106, 100, 100): Color.fromARGB(255, 222, 223, 224)
                  ),
                  
                  height: 60,
                  width: 60,
                  child: Icon(Icons.add,size: 30,color: Colors.deepPurpleAccent,),
                ),
                SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isDark?const Color.fromARGB(66, 106, 100, 100): const Color.fromARGB(255, 222, 223, 224)
                  ),
                  
                  height: 60,
                  width: 60,
                  child: Icon(Icons.mic,size: 30,color: Colors.deepPurpleAccent,),
                ),
                SizedBox(width: 5,),
                Expanded(
                  
                  child: TextField(
                    controller: sendTxtEditingController,
                    
                    decoration: InputDecoration(
                      
                      suffix: GestureDetector(
                        onTap: (){
                          final text =sendTxtEditingController.text;
                          sendTxtEditingController.text = "";
                          chats.doc(chatId).collection("messages").add({
                            "text":text,
                            "sender":currUser,
                            "reciver":targetUser,
                            "isSeen": false,
                            "timestamp": DateTime.now() 
                          }).then((onValue){
                            
                          });

                          
                        },
                        child: Icon(Icons.send,color: Colors.deepPurpleAccent,))
                      
                    ),

                  ),)


              ],
            ),
          )
        ],
      ),
    );
  }
}
