import 'package:flutter/material.dart';

// class RatingStars extends StatelessWidget {
//   final int numberOfStars;
//   final double starSize;
//   final Color fillColor;
//   final Color emptyColor;

//   const RatingStars({
//     super.key,
//     required this.numberOfStars,
//     this.starSize = 24.0,
//     this.fillColor = Colors.amber,
//     this.emptyColor = Colors.grey,
//   }) : assert(numberOfStars >= 0 && numberOfStars <= 5,
//             'numberOfStars must be between 0 and 5');

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(5, (index) {
//         return Padding(
//           padding: const EdgeInsets.only(right: 4.0),
//           child: Icon(
//             index < numberOfStars
//                 ? CupertinoIcons.star_fill
//                 : CupertinoIcons.star,
//             size: starSize,
//             color: index < numberOfStars ? fillColor : emptyColor,
//           ),
//         );
//       }),
//     );
//   }
// }

class RatingStars extends StatelessWidget {
  final double numberOfStars;
  final double starSize;
  final Color fillColor;
  final Color emptyColor;

  const RatingStars(
      {super.key,
      this.numberOfStars = 0,
      this.starSize = 24,
      this.emptyColor = Colors.grey,
      this.fillColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    List<Widget> starWidgets = [];

    // Full stars
    int fullStars = numberOfStars.floor();
    for (int i = 0; i < fullStars; i++) {
      starWidgets.add(Icon(Icons.star, size: starSize));
    }

    // Half star
    if (numberOfStars - fullStars >= 0.25 && numberOfStars - fullStars < 0.75) {
      starWidgets.add(Icon(Icons.star_half, size: starSize));
    }

    // Empty stars
    int emptyStars =
        5 - fullStars - (numberOfStars - fullStars >= 0.75 ? 1 : 0);
    for (int i = 0; i < emptyStars; i++) {
      starWidgets.add(Icon(Icons.star_border, size: starSize));
    }

    return Row(
      children: starWidgets,
    );
  }
}
