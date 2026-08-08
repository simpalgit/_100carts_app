import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController? controllerValue;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Widget? pref, suf;
  final bool? rOnly;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final bool? obsText;
  final int? mLength;
  final bool? isPartner;

  final String? Function(String?)? validate;
  final String? hintText;
  const LoginTextField(
      {super.key,
      this.pref,
      this.suf,
      this.controllerValue,
      this.obsText = false,
      this.validate,
      this.onTap,
      this.rOnly = false,
      this.isPartner = false,
      this.inputType,
      this.actionNext,
      this.mLength,
      this.hintText,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      enableInteractiveSelection: false,
      onChanged: onChange,
      style:
          GoogleFonts.mukta(fontSize: 14, letterSpacing: 1, color: blackColor),
      cursorColor: isPartner! ? primaryPartnerColor : primaryColor,
      readOnly: rOnly!,
      textInputAction: actionNext,
      onTap: onTap,
      keyboardType: inputType,
      obscureText: obsText!,
      validator: validate!,
      controller: controllerValue!,
      maxLength: mLength,
      decoration: InputDecoration(
        prefixIcon: pref,
        suffixIcon: suf,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        filled: false,
        counterText: '',
        errorStyle:
            GoogleFonts.mukta(color: Colors.red, fontWeight: FontWeight.w500),
        hintText: hintText,
        hintStyle: GoogleFonts.mukta(
          color: blackColor,
          fontSize: 12,
          letterSpacing: 1,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: blackColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isPartner! ? primaryPartnerColor : primaryColor,
                width: 1)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: blackColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}

class StepperTextField extends StatelessWidget {
  final TextEditingController? controllerValue;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Widget? pre;
  final bool? rOnly;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final bool? obsText;
  final int? maxLine, mLength;
  final bool? isPartner;

  final String? Function(String?)? validate;
  final String? hintValue;
  const StepperTextField(
      {super.key,
      this.pre,
      this.controllerValue,
      this.obsText = false,
      this.validate,
      this.onTap,
      this.rOnly = false,
      this.inputType,
      this.actionNext,
      this.mLength,
      this.maxLine,
      this.hintValue,
      this.isPartner = false,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      style: GoogleFonts.mukta(
          fontSize: 14, letterSpacing: 1, color: Colors.black),
      cursorColor: Colors.black87,
      readOnly: rOnly!,
      textInputAction: actionNext,
      maxLines: maxLine,
      onTap: onTap,
      keyboardType: inputType,
      obscureText: obsText!,
      validator: validate!,
      controller: controllerValue!,
      maxLength: mLength,
      decoration: InputDecoration(
          prefixIcon: pre,
          label: Text(hintValue!),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          filled: true,
          fillColor: Colors.white,
          counterText: '',
          hintText: hintValue,
          alignLabelWithHint: true,
          errorStyle: GoogleFonts.mukta(),
          hintStyle: GoogleFonts.mukta(
            fontSize: 12,
            letterSpacing: 1,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isPartner! ? primaryPartnerColor : primaryColor,
                  width: 2)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red)),
          labelStyle: GoogleFonts.mukta(color: Colors.black87, fontSize: 14)),
    );
  }
}
