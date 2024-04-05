// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RequiredInputLabel extends StatelessWidget {
  final String label;
  final bool? isRequired;
  final bool? isBold;
  const RequiredInputLabel({
    super.key,
    required this.label,
    this.isRequired,
    this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight:
                      (isBold == true) ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          if (isRequired == true)
            const TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
