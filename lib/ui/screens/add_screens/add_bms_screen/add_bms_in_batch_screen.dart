// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/value/value_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/add_screens/add_bms_screen/widgets/check_box_list_tile_widget.dart';
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
  List<bool> bmsCheckedList = [];
  Map<Bms, List<TextEditingController>> bmsSrNoControllerMap = {};

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
            bmsCheckedList = List.generate(bmsList.length, (index) => false);
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
                                    bmsCheckedList[state.index] = state.isAdded;
                                    if (state.isAdded) {
                                      bmsSrNoControllerMap[state.bms] = [
                                        TextEditingController()
                                      ];
                                    } else {
                                      bmsSrNoControllerMap[state.bms] = [];
                                    }
                                  } else if (state
                                      is SelectedBmsTextControllerChangedState) {
                                    if (state.isAdded) {
                                      bmsSrNoControllerMap[state.bms]
                                          ?.add(TextEditingController());
                                    } else {
                                      bmsSrNoControllerMap[state.bms]
                                          ?.removeAt(state.index);
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bmsList.length,
                                    itemBuilder: (context, index) {
                                      Bms bms = bmsList[index];
                                      bool isCheckBoxSelected =
                                          bmsCheckedList[index];
                                      return CheckboxListTileWidget(
                                          index: index,
                                          bms: bms,
                                          isCheckBoxSelected:
                                              isCheckBoxSelected,
                                          bmsSrNoControllerList:
                                              bmsSrNoControllerMap[bms] ?? []);
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
                              for (var element
                                  in bmsSrNoControllerMap.entries) {
                                print(element.key);
                                for (var text in element.value) {
                                  print(text.text);
                                }
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

  
}
