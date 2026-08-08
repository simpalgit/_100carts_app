import 'package:flutter/material.dart';
import 'package:carts_app/Utils/appcolors.dart';

// class PageLoaderScreen extends StatelessWidget {
//   const PageLoaderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             Images.loaderImage,
//             width: size.width * 0.3,
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           AnimatedTextKit(
//             animatedTexts: [
//               TypewriterAnimatedText(
//                 "Fetching data ..",
//                 speed: const Duration(milliseconds: 150),
//                 textStyle: GoogleFonts.mukta(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: blackColor,
//                     letterSpacing: 1.5),
//               ),
//             ],
//             isRepeatingAnimation: true,
//             repeatForever: true,
//             displayFullTextOnTap: true,
//             stopPauseOnTap: false,
//           ),
//         ],
//       ),
//     );
//   }
// }

class PageLoaderScreen extends StatelessWidget {
  const PageLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  var size = MediaQuery.of(context).size;
    return const Center(
        child: CircularProgressIndicator(
      color: primaryColor,
    ));
  }
}
