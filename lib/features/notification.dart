import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/notification_item.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            MyText(text: "Notifications",fontSize: 30,bold: true,),
            
            

            SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(itemBuilder: (context,index){
                return  NotificationItem(imgUrl: 'https://i.pravatar.cc/150?img=$index', 
                title: "Satyam", subtitle: "new follower", time: "5:00",isRead: index%2==0? true:false,);
              }),
            )

          ],
        ),
      ),
    );
  }
}