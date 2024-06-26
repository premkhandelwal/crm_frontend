import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

Widget buildTextFormFieldWithIcon({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  bool readOnly = false,
  int maxLines = 1,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10.0),
          prefixIcon: Icon(icon),
        ),
        maxLines: maxLines,
      ),
    ),
  );
}

Widget buildDatePickerFormFieldWithIcon({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  required BuildContext context,
  bool readOnly = false,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10.0),
          prefixIcon: Icon(icon),
        ),
        onTap: () async {
          await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          ).then((selectedDate) => {
                if (selectedDate != null)
                  {
                    controller.text =
                        DateFormat('dd-MM-yyyy').format(selectedDate)
                  }
              });
        },
      ),
    ),
  );
}
