import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool seenStatus;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.seenStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isMe
        ? const Color.fromARGB(255, 0, 111, 202)
        : isDark
        ? const Color.fromARGB(255, 61, 66, 74)
        : Colors.grey.shade300;

    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: !isMe
                          ? Color(0xFF1D232F)
                          : const Color.fromARGB(255, 65, 51, 107),
                      offset: Offset(4, 4),
                      blurRadius: 2,
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: MyText(text: text, fontSize: 15, bold: false),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: MyText(
                  text: seenStatus&&isMe
                      ? "Seen " + DateFormat('HH:mm a').format(timestamp)
                      : DateFormat('HH:mm a').format(timestamp),
                  fontSize: 11,
                  bold: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
