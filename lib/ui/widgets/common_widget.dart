import 'package:flutter/material.dart';

Widget buildDropdownFormFieldWithIcon<T>({
  required List<T> items,
  required T value,
  required void Function(T?) onChanged,
  required String labelText,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10.0),
        ),
      ),
    ),
  );
}
