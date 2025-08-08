import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyTextField extends StatefulWidget {
  final Icon icon; // Now used as prefixIcon
  final String hintText;
  final String? label;
  final IconData? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.label,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: widget.icon, // 👈 This puts the icon nicely inside the left
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Color(0xFF6C63FF),
                  ),
                )
              : (widget.suffixIcon != null
                  ? Icon(widget.suffixIcon, color: theme.iconTheme.color)
                  : null),
          hintText: widget.hintText,
          labelText: widget.label,
          filled: true,
          labelStyle: GoogleFonts.poppins(

          ),
          hintStyle: GoogleFonts.poppins(),
          fillColor:
              theme.inputDecorationTheme.fillColor ?? Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}



class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool bold;

  const MyText( {
    super.key,
    required this.text,
    this.fontSize = 16,
    this.bold = false,
    
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}




class MyProgressIndicator extends StatelessWidget {
  final double size;

  const MyProgressIndicator({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).brightness==Brightness.dark? Color(0xFF6C63FF):Color.fromARGB(255, 16, 15, 32);

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withOpacity(0.1),
                  primary.withOpacity(0.3),
                  primary.withOpacity(0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(primary),
            backgroundColor: primary.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  // 🔹 Static method to show the progress dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: MyProgressIndicator()),
    );
  }

  // 🔹 Static method to hide the progress dialog
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class AnimatedToast extends StatefulWidget {
  final String message;
  const AnimatedToast({super.key, required this.message});

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeTransition(
      opacity: _fade,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white30 : Colors.black12,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 1,
            )
          ],
        ),
        child: Text(
          widget.message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
  
}

void notify(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 80,
      left: 30,
      right: 30,
      child: Material(
        color: Colors.transparent,
        child: AnimatedToast(message: message),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

