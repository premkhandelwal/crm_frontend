import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_bms_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Harness> harnessList = [];
List<Make> makeList = [];

class AddBmsScreen extends StatefulWidget {
  final bool isEdit;
  final Bms? editBmsData;
  const AddBmsScreen({Key? key, this.isEdit = false, this.editBmsData})
      : super(key: key);

  @override
  State<AddBmsScreen> createState() => _AddBmsScreenState();
}

class _AddBmsScreenState extends State<AddBmsScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController bmsNameController = TextEditingController();
  TextEditingController bmsDescriptionController = TextEditingController();

  late MasterBloc masterBloc;

  List<Harness> selectedHarness = [];
  Make? selectedMake;

  @override
  void initState() {
    if (widget.isEdit) {
      bmsNameController.text = widget.editBmsData!.name;
      bmsDescriptionController.text = widget.editBmsData!.details;
    }
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchHarnessEvent());
    masterBloc.add(FetchMakeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Bms"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchHarnessState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            harnessList = List.from(customerState.harnessList);
            if (widget.isEdit) {
              //selectedHarness
              for (var harnessId in widget.editBmsData!.harnessDetails) {
                selectedHarness.add(harnessList
                    .firstWhere((element) => element.id == harnessId));
              }
            }
          } else if (customerState is FetchMakeState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            makeList = List.from(customerState.makeList);
            if (widget.isEdit) {
              selectedMake = makeList.firstWhere(
                  (element) => element.id == widget.editBmsData!.makeId);
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildTextFormFieldWithIcon(
                      controller: bmsNameController,
                      labelText: 'Bms Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    buildTextFormFieldWithIcon(
                      controller: bmsDescriptionController,
                      labelText: 'Bms Description',
                      icon: Icons.person,
                    ),
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Select Harness:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...harnessList.map((item) {
                        return Row(
                          children: [
                            Checkbox(
                              value: selectedHarness.contains(item),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedHarness.add(item);
                                  } else {
                                    selectedHarness.remove(item);
                                  }
                                });
                              },
                            ),
                            Text(item.name),
                            const SizedBox(
                                width:
                                    16.0), // Adjust the spacing between checkboxes
                          ],
                        );
                      }).toList(),
                    ]),
                    buildDropdownFormFieldWithIcon<Make?>(
                      items: makeList,
                      value: selectedMake,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedMake = newValue;
                        });
                      },
                      labelText: 'Select the Make',
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<MasterBloc, MasterState>(
                      listener: (context, state) {
                        if (state is AddBmsState || state is EditBmsState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Bms ${widget.isEdit ? 'edited' : 'added'} successfully")));
                            context
                                .read<AppCubit>()
                                .appPageChaged(const ViewBmsScreen());
                          } else if (state.submissionStatus ==
                              SubmissionStatus.failure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Failed to ${widget.isEdit ? 'edit' : 'add'} bms")));
                          }
                        }
                      },
                      builder: (context, state) {
                        if ((state is AddBmsState || state is EditBmsState) &&
                            state.submissionStatus ==
                                SubmissionStatus.inProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Handle form submission
                              // Access the form field values using the controllers
                              Bms bmsData = Bms(
                                name: bmsNameController.text,
                                details: bmsDescriptionController.text,
                                harnessDetails: selectedHarness
                                    .map((harness) => harness.id)
                                    .toList(),
                                makeId: selectedMake!.id,
                              );
                              if (widget.isEdit) {
                                bmsData = bmsData.copyWith(
                                    id: widget.editBmsData!.id);
                                masterBloc.add(EditBmsEvent(bmsData: bmsData));
                              } else {
                                masterBloc.add(AddBmsEvent(bmsData: bmsData));
                              }
                            }
                          },
                          child: const Text('Submit'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextFormFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
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
}
