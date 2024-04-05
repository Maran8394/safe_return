// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final bool? isRequired;
  final String? hintText;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool? obsecureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Function()? onTap;
  const InputWidget({
    super.key,
    this.isRequired,
    this.hintText,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obsecureText,
    this.keyboardType,
    this.validator,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: (readOnly == true) ? true : false,
      keyboardType: keyboardType ?? TextInputType.text,
      controller: controller,
      obscureText: obsecureText ?? false,
      textAlignVertical: TextAlignVertical.center,
      maxLines: maxLines,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0, fontSize: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade500,
          ),
        ),
        fillColor: (readOnly != true) ? Colors.white : Colors.grey.shade500,
        filled: true,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.grey.shade400,
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.amber,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      validator: (isRequired == true)
          ? (dynamic value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              return null;
            }
          : null,
    );
  }
}
