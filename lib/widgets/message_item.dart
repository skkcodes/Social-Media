import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final String imgUrl;
  final String senderName;
  final String message;
  final Timestamp time;

  const MessageItem({
    super.key,
    required this.imgUrl,
    required this.senderName,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;

    

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black87 : Colors.grey.shade300,
            offset: const Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: isDark ? const Color.fromARGB(255, 20, 4, 40) : const Color.fromARGB(255, 229, 218, 245),
            offset: const Offset(0, 0),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Profile Picture
          StoryItem(imageUrl: imgUrl, userName: "",radius: 25,),

          const SizedBox(width: 12),

          // 🟢 Message Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(text: senderName,
                    bold: true,
                    fontSize: 20,
                    ),
                    MyText(
                      text:  DateFormat('hh:mm a').format(time.toDate()),
                      fontSize: 12,

                      
                     
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Message
                MyText(text: message,fontSize: 13,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
