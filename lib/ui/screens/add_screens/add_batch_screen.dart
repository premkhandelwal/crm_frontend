// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_batch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];
List<Bms> bmsList = [];
List<Harness> harnessList = [];
List<Make> makeList = [];



class AddBatchScreen extends StatefulWidget {
  final bool isEdit;
  final Batch? editBatch;
  const AddBatchScreen({Key? key, this.isEdit = false, this.editBatch})
      : super(key: key);

  @override
  State<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends State<AddBatchScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController batchNameController = TextEditingController();
  TextEditingController batchDescriptionController = TextEditingController();

  late CustomerBloc customerBloc;

  Customer? selectedCustomer;
  Bms? selectedBms;
  List<Harness> selectedHarness = [];
  Make? selectedMake;

  @override
  void initState() {
    if (widget.isEdit) {
      batchNameController.text = widget.editBatch!.batchName;
    }
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    customerBloc.add(FetchBmsEvent());
    customerBloc.add(FetchCustomerEvent());
    customerBloc.add(FetchHarnessEvent());
    customerBloc.add(FetchMakeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Batch"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(customerState.customerList);
            if (widget.isEdit) {
              selectedCustomer = customerList.firstWhere(
                  (element) => element.id == widget.editBatch!.customerId);
            }
          } else if (customerState is FetchBmsState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            bmsList = List.from(customerState.bmsList);
            if (widget.isEdit) {
              selectedBms = bmsList.firstWhere(
                  (element) => element.id == widget.editBatch!.bmsId);
            }
          } else if (customerState is FetchHarnessState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            harnessList = List.from(customerState.harnessList);
            if (widget.isEdit) {
              //selectedHarness
              for (var harnessId in widget.editBatch!.harnessDetails) {
                selectedHarness.add(harnessList
                    .firstWhere((element) => element.id == harnessId));
              }
            }
          } else if (customerState is FetchMakeState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            makeList = List.from(customerState.makeList);
            if (widget.isEdit) {
              selectedMake = makeList.firstWhere(
                  (element) => element.id == widget.editBatch!.makeId);
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
                      controller: batchNameController,
                      labelText: 'Batch Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    buildDropdownFormFieldWithIcon<Bms?>(
                      items: bmsList,
                      value: selectedBms,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedBms = newValue;
                        });
                      },
                      labelText: 'Select the BMS',
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
                    buildDropdownFormFieldWithIcon<Customer?>(
                      items: customerList,
                      value: selectedCustomer,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedCustomer = newValue;
                        });
                      },
                      labelText: 'Select the Customer',
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<CustomerBloc, CustomerState>(
                      listener: (context, state) {
                        if (state is AddBatchState || state is EditBatchState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Batch ${widget.isEdit ? 'edited' : 'added'} successfully")));
                            context
                                .read<AppCubit>()
                                .appPageChaged(const ViewBatchScreen());
                          } else if (state.submissionStatus ==
                              SubmissionStatus.failure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Failed to ${widget.isEdit ? 'edit' : 'add'} details")));
                          }
                        }
                      },
                      builder: (context, state) {
                        if ((state is AddBatchState ||
                                state is EditBatchState) &&
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
                              Batch batchData = Batch(
                                batchName: batchNameController.text,
                                bmsId: selectedBms!.id,
                                customerId: selectedCustomer!.id,
                                harnessDetails: selectedHarness
                                    .map((harness) => harness.id)
                                    .toList(),
                                makeId: selectedMake!.id,
                              );
                              if (widget.isEdit) {
                                batchData.id = widget.editBatch!.id;
                                customerBloc
                                    .add(EditBatchEvent(batchData: batchData));
                              } else {
                                customerBloc
                                    .add(AddBatchEvent(batchData: batchData));
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
}
