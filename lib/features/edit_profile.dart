import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagi_go_ai/model/user_model.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  
  const EditProfile({super.key, });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameTextEditingController = TextEditingController();

  final usernameTextEditingController = TextEditingController();

  final emailTextEditingController = TextEditingController();

  final bioTextEditingController = TextEditingController();
  late String currentImgUrl;
  

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context,listen: false).user;
    nameTextEditingController.text=user!.name;
    usernameTextEditingController.text=user.username;
    emailTextEditingController.text=user.email;
    bioTextEditingController.text=user.bio;
    currentImgUrl=user.imgUrl;
    
  }

  @override
  void dispose() {

    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    bioTextEditingController.dispose();
    usernameTextEditingController.dispose();
    super.dispose();
  }

 void uploadProfileImage(  ) async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  final user = Provider.of<UserProvider>(context,listen: false).user;
  if (pickedImage == null) return;

  final file = File(pickedImage.path);
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final fileName = "$uid.jpg"; // You can change this to something timestamp-based if needed
  final storageRef = FirebaseStorage.instance.ref().child("user_images/$fileName");

  try {
    // ✅ Delete old image if it exists
    if (user?.imgUrl != null && user!.imgUrl.isNotEmpty) {
      try {
        await FirebaseStorage.instance.refFromURL(user.imgUrl).delete();
      } catch (e) {
        debugPrint("Old image deletion error (might not exist): $e");
      }
    }

    // ✅ Upload new image
    final uploadTask = await storageRef.putFile(file);
    final newImageUrl = await uploadTask.ref.getDownloadURL();

    // ✅ Save new image URL to Firestore
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "imgUrl": newImageUrl,
    });
    setState(() {
      currentImgUrl = newImageUrl;
    }); 
    
    notify(context, "Profile photo uploaded sucessfully");

  } catch (e) {
    notify(context, "Profile photo upload failed");
  }
  
}


  

  

  void updateUser()async{
    MyProgressIndicator.show(context);
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    final currentUser = userProvider.user;
    if (currentUser == null) return ;

    UserModel updatedUser = currentUser.copyWith(
      name: nameTextEditingController.text,
      email: emailTextEditingController.text,
      bio: bioTextEditingController.text,
      username: usernameTextEditingController.text,
      imgUrl: currentImgUrl
      

      
      
      
    );

    await userProvider.updateUser(updatedUser);
    MyProgressIndicator.hide(context);
    Navigator.pop(context);
    
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<UserProvider>(
      builder: (context, value, child) =>  Scaffold(
        appBar: AppBar(
          title: MyText(text: "Profile", fontSize: 44, bold: true),
          actions: [IconButton(onPressed: () => updateUser(),icon: Icon(Icons.check),)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
  children: [
    StoryItem(imageUrl: currentImgUrl, userName: "",radius: 70,),
    // 🖉 Pencil Icon
    Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: uploadProfileImage,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF6C63FF),
            shape: BoxShape.circle,
            border: Border.all(color: isDark? Colors.black:Colors.white)
            
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.edit,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
),

              SizedBox(height: 10),
              
              
              MyTextField(hintText: "", icon: Icon(Icons.person),label: "Name",controller: nameTextEditingController,),
              
              SizedBox(height: 10),
              MyTextField(hintText: "", icon: Icon(CupertinoIcons.profile_circled),label: "Userame",controller: usernameTextEditingController,),
              SizedBox(height: 10),
              MyTextField(hintText: "", icon: Icon(Icons.mail),label: "Email",controller: emailTextEditingController,),
              SizedBox(height: 10),
              MyTextField(hintText: "", icon: Icon(Icons.abc),label: "Bio",controller: bioTextEditingController,),
              
      
              SizedBox(height: 20,),
              SizedBox(
                    height: 60,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: updateUser,
                      child: MyText(text: "Update", bold: true),
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
