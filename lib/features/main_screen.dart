import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagi_go_ai/features/chat.dart';
import 'package:imagi_go_ai/features/home.dart';
import 'package:imagi_go_ai/features/notification.dart';
import 'package:imagi_go_ai/features/post.dart';
import 'package:imagi_go_ai/features/profile.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/my_navbar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    loadUser();
  }

  

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onPostPressed() async {
    final picker = ImagePicker();
    final  _imgFile =await picker.pickImage(source: ImageSource.gallery) ;
    if(_imgFile?.path != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Post(imgFile: File(_imgFile!.path),)));

    }
    
  }

  Future<void> loadUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser();
    setState(() {
      _loading = false;
    });
  }

  final List<Widget> _pages = [
    Home(),
    Chat(),
    Notifications(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {

    if(_loading){
      return Scaffold(body: Center(child: MyProgressIndicator()));
    }
    
    return MyNavbar(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      selectedIndex: _selectedIndex,
      onTabSelected: _onTabSelected,
      onPostPressed: _onPostPressed,
    );
  }
}
