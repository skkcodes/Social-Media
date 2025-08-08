import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/model/user_model.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/search_item.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search> {
  final searchTextEditingController = TextEditingController();
  List<UserModel> searchedUsers = [];
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  // 🔥 Map to track follow state for each user by UID
  Map<String, bool> followMap = {};

  Future<List<UserModel>> searchUsers(String query) async {
    final ref = FirebaseFirestore.instance.collection('users');
    final lowerQuery = query.toLowerCase();

    final snapshot = await ref.get();

    final filteredUsers = snapshot.docs.where((doc) {
      final data = doc.data();
      final name = (data['name'] ?? '').toString().toLowerCase();
      final username = (data['username'] ?? '').toString().toLowerCase();
      return name.contains(lowerQuery) || username.contains(lowerQuery);
    }).toList();

    return filteredUsers
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  void handleSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchedUsers = [];
        followMap.clear();
      });
      return;
    }

    final results = await searchUsers(query.trim());

    // Update local follow state map
    final newFollowMap = <String, bool>{};
    for (var user in results) {
      newFollowMap[user.uid] = user.followers.contains(_uid);
    }

    setState(() {
      searchedUsers = results;
      followMap = newFollowMap;
    });
  }

  // 🧠 Toggle follow state for one user
  void toggleFollowState(String uid) {
    setState(() {
      followMap[uid] = !(followMap[uid] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 30),
              ),
            ),
            MyTextField(
              hintText: "",
              icon: const Icon(Icons.search),
              label: "Search here...",
              controller: searchTextEditingController,
              onChanged: handleSearch,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchedUsers.length,
                itemBuilder: (context, index) {
                  final user = searchedUsers[index];
                  final isFollowing = followMap[user.uid] ?? false;
                  final provider = context.watch<UserProvider>();
                  final currUser = provider.user;

                  if ( user.uid == currUser!.uid ) return SizedBox();

                  return SearchItem(
                    imgUrl: user.imgUrl,
                    name: user.name,
                    bio: user.bio,
                    isFollow: isFollowing,
                    onPressed: () async {
                      final usersRef = FirebaseFirestore.instance.collection("users");
                      
                      final targetUserRef = usersRef.doc(user.uid);

                      
                      final targetUserSnap = await targetUserRef.get();

                      List<dynamic> targetFollowers = targetUserSnap.data()?['followers'] ?? [];
                      

                      if (isFollowing) {
                        targetFollowers.remove(_uid);
                        currUser.following.remove(user.uid);
                      } else {
                        targetFollowers.add(_uid);
                        
                        currUser.following.add(user.uid);
                
                      }

                      await targetUserRef.update({'followers': targetFollowers});
                      await provider.updateUser(currUser);
                     

                      // ✅ Locally update button state
                      toggleFollowState(user.uid);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
