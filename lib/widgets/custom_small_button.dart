import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomSmallButton extends StatelessWidget {
  final dynamic text;
  final Function() onPressed;
  const CustomSmallButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return HexColor("#3E60AD");
              // return Colors.white;
            }
            return HexColor("#3E60AD");
          },
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          const Size.fromHeight(35),
        ),
      ),
      onPressed: onPressed,
      child: (text.runtimeType.toString() == "String")
          ? Text(
              text,
              style: GoogleFonts.dmSans(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            )
          : text,
    );
  }
}
