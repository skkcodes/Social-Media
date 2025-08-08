import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/model/user_model.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final File imgFile;
  Post({super.key, required this.imgFile});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final captionTextEditingController =TextEditingController();

  

  Future<void> _post(provider) async {

    MyProgressIndicator.show(context);
    final database =FirebaseFirestore.instance.collection("posts");
    final postId = DateTime.now().microsecondsSinceEpoch.toString();
    
    final storage = FirebaseStorage.instance.ref("post_images").child(DateTime.now().toString());
    var user = provider.user;

    

    final uploadTask = await storage.putFile(widget.imgFile);
    final imgUrl = await uploadTask.ref.getDownloadURL();

    final Map<String,dynamic> map = {
      "postId":postId,
      "imgUrl":imgUrl,
      "title":captionTextEditingController.text,
      "comments":[],
      "likes":[],
      "createdAt":DateTime.now(),
      "uid":user.uid
    };
    user.posts.add(postId);

    database.doc(postId).set(map).then((value){
      provider.updateUser(user);
      MyProgressIndicator.hide(context);
      Navigator.pop(context);
      notify(context, "Post Successful");
      }
    ).catchError((e){
      notify(context, e.toString());
    });



  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 300, // or any height you need
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6C63FF),
                      blurRadius: 8,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    widget.imgFile,
                    fit: BoxFit
                        .cover, // you can also try BoxFit.contain or BoxFit.fill based on your preference
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              SizedBox(height: 20),

              MyTextField(hintText: "", icon: Icon(Icons.edit),label: "Add a caption...",controller: captionTextEditingController,),

              SizedBox(height: 20,),
              
            SizedBox(
                    height: 60,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: (){
                        _post(provider);
                      },
                      child: MyText(text: "Post", bold: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
