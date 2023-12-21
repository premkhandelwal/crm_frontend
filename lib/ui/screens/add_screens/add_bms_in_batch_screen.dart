// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/value/value_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];
List<Batch> batchList = [];
List<Bms> bmsList = [];

class AddBmsInBatchScreen extends StatefulWidget {
  const AddBmsInBatchScreen({Key? key}) : super(key: key);

  @override
  State<AddBmsInBatchScreen> createState() => _AddBmsInBatchScreenState();
}

class _AddBmsInBatchScreenState extends State<AddBmsInBatchScreen> {
  final _formKey = GlobalKey<FormState>();

  late MasterBloc masterBloc;

  Batch? selectedBatch;
  Customer? selectedCustomer;
  List<Batch> batchListForCustomer = [];
  List<Bms> selectedBmsList = [];
  List<BatchBms> selectedBatchBmsList = [];

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchCustomerEvent());
    masterBloc.add(FetchBatchEvent());
    masterBloc.add(FetchBmsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bms in Batch"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is FetchCustomerState &&
              state.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(state.customerList);
          } else if (state is FetchBatchState &&
              state.submissionStatus == SubmissionStatus.success) {
            batchList = List.from(state.batchList);
          } else if (state is FetchBmsState &&
              state.submissionStatus == SubmissionStatus.success) {
            bmsList = List.from(state.bmsList);
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
                    buildDropdownFormFieldWithIcon<Customer?>(
                      items: customerList,
                      value: selectedCustomer,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          context.read<InfoBloc>().add(
                              FetchBatchForCustomerEvent(
                                  customerId: newValue.id));
                        }

                        setState(() {
                          selectedCustomer = newValue;
                        });
                      },
                      labelText: 'Select the Customer',
                    ),
                    if (selectedCustomer != null)
                      BlocConsumer<InfoBloc, InfoState>(
                        listener: (context, state) {
                          if (state is FetchBatchForCustomerState &&
                              state.submissionStatus ==
                                  SubmissionStatus.success) {
                            batchListForCustomer = List.from(state.batchList);
                          }
                        },
                        builder: (context, state) {
                          return buildDropdownFormFieldWithIcon<Batch?>(
                            items: batchListForCustomer,
                            value: selectedBatch,
                            onChanged: (newValue) {
                              // Handle the value change

                              setState(() {
                                selectedBatch = newValue;
                              });
                            },
                            labelText: 'Select the Batch',
                          );
                        },
                      ),
                    if (selectedBatch != null)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'List of BMS:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BlocConsumer<ValueCubit, ValueState>(
                                listener: (context, state) {
                                  if (state is SelectedBmsChangedState) {
                                    if (state.isAdded) {
                                      selectedBmsList.add(state.bms);
                                    } else {
                                      selectedBmsList.remove(state.bms);
                                      selectedBatchBmsList.removeWhere(
                                          (element) =>
                                              element.bmsId == state.bms.id);
                                    }
                                  } else if (state
                                      is SelectedBmsSerialNoChangedState) {
                                    BatchBms batchBms = BatchBms(
                                        bmsId: state.bms.id,
                                        serialNo: state.serialNo);
                                    if (!selectedBatchBmsList
                                        .contains(batchBms)) {
                                      selectedBatchBmsList.add(batchBms);
                                    }
                                  } else if (state is RemoveSerialNoState) {
                                    BatchBms batchBms = BatchBms(
                                        bmsId: state.bms.id,
                                        serialNo: state.serialNo);
                                    selectedBatchBmsList.remove(batchBms);
                                  }
                                },
                                buildWhen: (prev, curr) {
                                  if (curr is SelectedBmsSerialNoChangedState) {
                                    return true;
                                  }
                                  return false;
                                },
                                builder: (context, state) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bmsList.length,
                                    itemBuilder: (context, index) {
                                      Bms bms = bmsList[index];
                                      
                                      return CheckBoxListTileWidget(
                                          bms: bms,
                                          isSelected:
                                              selectedBmsList.contains(bms));
                                    },
                                  );
                                },
                              )),
                        ],
                      ),
                    const SizedBox(height: 20),
                    BlocConsumer<MasterBloc, MasterState>(
                      listener: (context, state) {
                        if (state is AddBmsInBatchState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Added BMS in batch successfully")));
                          } else if (state.submissionStatus ==
                              SubmissionStatus.failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Failed to add bms in batch")));
                          }
                        }
                      },
                      builder: (context, state) {
                        if ((state is AddBmsInBatchState) &&
                            state.submissionStatus ==
                                SubmissionStatus.inProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                selectedBatch != null) {
                              for (var element in selectedBatchBmsList) {
                                print("${element.bmsId} ${element.serialNo}");
                              }
                              /* masterBloc.add(AddBmsInBatchEvent(
                                  batchData: Batch(
                                      id: selectedBatch!.id,
                                      batchName: selectedBatch!.batchName,
                                      customerId: selectedBatch!.customerId,
                                      bmsList: List.from(
                                          selectedBmsList.map((e) => e.id))))); */
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

class CheckBoxListTileWidget extends StatefulWidget {
  final Bms bms;
  final bool isSelected;

  const CheckBoxListTileWidget({
    Key? key,
    required this.bms,
    required this.isSelected,
  }) : super(key: key);

  @override
  _CheckBoxListTileWidgetState createState() => _CheckBoxListTileWidgetState();
}

class _CheckBoxListTileWidgetState extends State<CheckBoxListTileWidget> {
  List<TextEditingController> controllers = [];
  @override
  Widget build(BuildContext context) {
    ValueCubit valueCubit = BlocProvider.of<ValueCubit>(context);
    bool isCheckBoxSelected = widget.isSelected;

    return BlocBuilder<ValueCubit, ValueState>(
      buildWhen: (prev, curr) {
        if (curr.bms?.id == widget.bms.id) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is SelectedBmsChangedState) {
          isCheckBoxSelected = state.isAdded;
        }

        return CheckboxListTile(
          title: Text(
            widget.bms.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: isCheckBoxSelected
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: controllers.length,
                  itemBuilder: (context, ind) {
                    FocusNode node = FocusNode();
                    return Focus(
                      onFocusChange: (isFocused) {
                        if (!isFocused) {
                          valueCubit.selectedBmsSerialNoChanged(
                              widget.bms, controllers[ind].text);
                        }
                      },
                      child: TextFormField(
                        focusNode: node,
                        onTap: () {
                          
                        },
                        controller: controllers[ind],
                        decoration: InputDecoration(
                            hintText: "Enter BMS Serial Number",
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: ind == 0
                                ? IconButton(
                                    onPressed: () {
                                      controllers.add(TextEditingController());
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.add))
                                : IconButton(
                                    onPressed: () {
                                      valueCubit.removeSerialNo(
                                          widget.bms, controllers[ind].text);
                                      controllers.removeAt(ind);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ))),
                      ),
                    );
                  })
              : null,
          value: isCheckBoxSelected,
          onChanged: (value) {
            if (value != null && value) {
              // Add a new controller when the checkbox is selected
              controllers = [TextEditingController()];
              valueCubit.selectedBmsChanged(widget.bms, true);
            } else {
              controllers = [];
              valueCubit.selectedBmsChanged(widget.bms, false);
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.blue,
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose of all controllers when the widget is disposed
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
