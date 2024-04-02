import 'package:flutter/material.dart';

Widget buildDropdownFormField<T>({
  required T? value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
  required String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    onChanged: onChanged,
    validator: validator,
    items: items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(item.toString()),
      );
    }).toList(),
  );
}

Widget buildTextFormField({
  required String labelText,
  required String? value,
  required ValueChanged<String?> onChanged,
  required String? Function(String?)? validator,
  VoidCallback? onSuffixIconTap,
}) {
  return TextFormField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      labelText: labelText,
      suffixIcon: onSuffixIconTap != null
          ? GestureDetector(
              onTap: onSuffixIconTap,
              child: const Icon(Icons.delete),
            )
          : null,
    ),
    initialValue: value,
    onChanged: onChanged,
    validator: validator,
  );
}
