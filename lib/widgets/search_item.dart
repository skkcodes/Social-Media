import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:imagi_go_ai/widgets/story_item.dart';

class SearchItem extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String bio;
  bool isFollow;
  final void Function()? onPressed;

  SearchItem({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.bio,
    this.isFollow = false, 
    this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          // 🔵 Profile Picture
          StoryItem(imageUrl: imgUrl, userName: "",radius: 26,),

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
                    MyText(text: name,bold: true, fontSize: 20,),
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: onPressed ,
                        child: isFollow
                            ? MyText(
                                text: "Following",
                                bold: false,
                                fontSize: 15,
                              )
                            : MyText(text: "Follow", bold: true, fontSize: 15),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Message
                MyText(text: bio,fontSize: 13,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
