import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';

class NotificationItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isRead
        ? theme.scaffoldBackgroundColor
        : (isDark ? Colors.deepPurple.shade900 : Colors.purple.shade50);

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
            color: isDark
                ? const Color.fromARGB(255, 20, 4, 40)
                : const Color.fromARGB(255, 229, 218, 245),
            offset: const Offset(0, 0),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔔 User or App Icon
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(imgUrl),
          ),

          const SizedBox(width: 12),

          // 📣 Notification Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: title,bold: true,fontSize: 20,),
                const SizedBox(height: 4),
                MyText(text: subtitle,fontSize: 12,),
                const SizedBox(height: 6),
                MyText(text: time,fontSize: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
