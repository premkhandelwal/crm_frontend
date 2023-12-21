import 'package:crm/logic/cubits/value/value_cubit.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/ui/screens/add_screens/add_bms_screen/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckboxListTileWidget extends StatelessWidget {
  const CheckboxListTileWidget({
    super.key,
    required this.index,
    required this.bms,
    required this.isCheckBoxSelected,
    required this.bmsSrNoControllerList,
  });

  final int index;
  final Bms bms;
  final bool isCheckBoxSelected;
  final List<TextEditingController> bmsSrNoControllerList;

  @override
  Widget build(BuildContext context) {
    final ValueCubit valueCubit = BlocProvider.of<ValueCubit>(context);
    return CheckboxListTile(
      title: Text(
        bms.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: isCheckBoxSelected
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: bmsSrNoControllerList.length,
              itemBuilder: (context, ind) {
                return TextFormFieldWidget(
                  controller: bmsSrNoControllerList[ind],
                  bms: bms,
                  ind: ind,
                );
              })
          : null,
      value: isCheckBoxSelected,
      onChanged: (value) {
        if (value != null && value) {
          valueCubit.selectedBmsChanged(bms, true, index);
        } else {
          valueCubit.selectedBmsChanged(bms, false, index);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blue,
    );
  }
}
