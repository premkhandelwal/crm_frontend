import 'package:crm/logic/cubits/bmsValue/bms_value_cubit.dart';
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
    final BmsValueCubit bmsValueCubit = BlocProvider.of<BmsValueCubit>(context);

    return TextFormField(
      onTap: () {},
      controller: controller,
      decoration: InputDecoration(
          hintText: "Enter BMS Serial Number",
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: ind == 0
              ? IconButton(
                  onPressed: () {
                    bmsValueCubit.selectedBmsTextControllerChanged(bms, true, ind, DateTime.now());
                  },
                  icon: const Icon(Icons.add))
              : IconButton(
                  onPressed: () {
                    bmsValueCubit.selectedBmsTextControllerChanged(
                        bms, false, ind, DateTime.now());
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ))),
    );
  }
}
