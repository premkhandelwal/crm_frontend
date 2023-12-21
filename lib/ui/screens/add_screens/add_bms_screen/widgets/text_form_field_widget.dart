import 'package:crm/logic/cubits/value/value_cubit.dart';
import 'package:crm/models/bms_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.ind,
    required this.controller,
    required this.bms,
  });
  final int ind;
  final TextEditingController controller;
  final Bms bms;

  @override
  Widget build(BuildContext context) {
    final ValueCubit valueCubit = BlocProvider.of<ValueCubit>(context);

    return TextFormField(
      onTap: () {},
      controller: controller,
      decoration: InputDecoration(
          hintText: "Enter BMS Serial Number",
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: ind == 0
              ? IconButton(
                  onPressed: () {
                    valueCubit.selectedBmsTextControllerChanged(bms, true, ind);
                  },
                  icon: const Icon(Icons.add))
              : IconButton(
                  onPressed: () {
                    valueCubit.selectedBmsTextControllerChanged(
                        bms, false, ind);
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ))),
    );
  }
}