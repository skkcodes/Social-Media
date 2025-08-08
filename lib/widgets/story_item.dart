import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryItem extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final bool isViewed;
  final double radius;
  

  const StoryItem({
    super.key,
    required this.imageUrl,
    required this.userName,
    this.isViewed = false,
    this.radius=30,
    
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final gradientColors = isViewed
        ? [Colors.grey.shade800, Colors.grey.shade600]
        : [
            primary.withOpacity(0.9),
            Colors.cyanAccent.withOpacity(0.7),
            Colors.purpleAccent.withOpacity(0.6),
          ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(02),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: gradientColors,
              startAngle: 0.0,
              endAngle: 3.14 * 2,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(03),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ),
        text(userName, context)

        
        
      ],
    );
  }
}

Widget text(userName,context){
  if (userName=="") return Container();
  return Column(
    children: [
      const SizedBox(height: 06),
        SizedBox(
          width: 70,
          child: Text(
  userName,
  style: GoogleFonts.poppins(
    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodySmall?.color,
  ),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  textAlign: TextAlign.center,
)
        ),
    ],
  );
}
