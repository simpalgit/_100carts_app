import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carts_app/Utils/appcolors.dart';

class UploadImagesHelper extends StatelessWidget {
  final String? imagePath;

  final VoidCallback uploadImage, removeImage;
  final CroppedFile? passedfile;
  const UploadImagesHelper(
      {super.key,
      required this.uploadImage,
      required this.removeImage,
      this.passedfile,
      this.imagePath = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        passedfile == null
            ? imagePath != ""
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: secondaryColor)),
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          // child: CustomImage(path: imagePath!),
                          // child: CustomImage(path: imagePath!),
                          child: CachedNetworkImage(
                              imageUrl: imagePath!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.black12,
                                          highlightColor: Colors.white,
                                          enabled: true,
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: const BoxDecoration(
                                                color: Colors.white70,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                              errorWidget: (context, url, error) => Container(
                                  color: primaryColor,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Add\nLogo',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mukta(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        ),
                      ),
                      InkWell(
                          onTap: uploadImage,
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              'Upload',
                              style: GoogleFonts.mukta(color: Colors.white),
                            ),
                          )),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: uploadImage,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: blackColor,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        height: 140,
                        width: 150,
                        child: Text(
                          '+ Upload',
                          style: GoogleFonts.mukta(
                              fontWeight: FontWeight.w500, color: blackColor),
                        ),
                      ),
                    ),
                  )
            : Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: uploadImage,
                        child: Image.file(
                          File(passedfile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                        onTap: removeImage,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: const Icon(
                            Icons.close,
                            color: whiteColor,
                          ),
                        )),
                  ),
                ],
              )
      ],
    );
  }
}
