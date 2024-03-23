import 'package:firebase_integration/profile/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class OTPTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if (newValue.text.length > 1) {
      return const TextEditingValue().copyWith(
          text: newValue.text.substring(0, 1));
    }
    return newValue;
  }
}

class RoundedTextField extends StatefulWidget {
  const RoundedTextField({super.key,this.unFocus,this.previousFocus, required this.controller});
  final String? unFocus;
  final String? previousFocus;
  final TextEditingController controller;

  @override
  RoundedTextFieldState createState() => RoundedTextFieldState();
}

class RoundedTextFieldState extends State<RoundedTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    widget.controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, OTPTextInputFormatter()],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            widget.unFocus != null ? FocusScope.of(context).unfocus() :
            FocusScope.of(context).nextFocus();
          }else{
            if(widget.previousFocus == null) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }
}
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _navigateToProfilePage(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/rolex.svg',color: Colors.purple,),
          ],
        ),
      ),
    );
  }
  void _navigateToProfilePage(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    });
  }
}


