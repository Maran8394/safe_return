// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

class AutoSuggestDropDown extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onSelected;
  final bool? disabled;
  final String? initialValue;
  final String hintText;
  final List<String> options;
  final FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
  final TextInputType? textInputType;
  final int? maxLength;
  const AutoSuggestDropDown({
    super.key,
    this.onChanged,
    this.onSelected,
    this.disabled,
    this.initialValue,
    required this.hintText,
    required this.options,
    required this.optionsBuilder,
    this.textInputType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue:
          initialValue != null ? TextEditingValue(text: initialValue!) : null,
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController controller,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          textCapitalization: TextCapitalization.characters,
          enableSuggestions: (disabled == true) ? false : true,
          readOnly: (disabled == true) ? true : false,
          controller: controller,
          focusNode: focusNode,
          keyboardType: textInputType,
          maxLength: maxLength,
          onFieldSubmitted: (value) {
            onFieldSubmitted();
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.only(left: 10),
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: (disabled == true) ? Colors.grey.withOpacity(0.9) : null,
              ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.76,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
