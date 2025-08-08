import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagi_go_ai/model/user_model.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  
  
  UserModel? get user => _user;

  Future<void> fetchUser() async {
  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists) {
      final newUser = UserModel.fromMap(doc.data()!, uid);

      if (_user == null || newUser.uid != _user!.uid ) {
        _user = newUser;
        // ✅ Notify only if user is updated
        notifyListeners();
        
      }
    }
  } catch (e) {
    debugPrint('Fetch user error: $e');
  }
}


  

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Update user error: $e');
    }
  }




}

