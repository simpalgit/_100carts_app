import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class WatchExampleButton extends StatelessWidget {
  final String image, title;
  const WatchExampleButton(
      {super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: darkBlueColor),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: whiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mukta(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            content: Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              child: Container(
                height: size.height * 0.25,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fitHeight,
                    )),
              ),
            ),
          ),
        );
      },
      child: Text(
        'Watch Example',
        style:
            GoogleFonts.mukta(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
