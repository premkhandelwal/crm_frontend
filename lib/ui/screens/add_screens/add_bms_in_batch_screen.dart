// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<Bms> selectedBmsList = [];

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
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
          if (state is FetchBatchState &&
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
                    buildDropdownFormFieldWithIcon<Batch?>(
                      items: batchList,
                      value: selectedBatch,
                      onChanged: (newValue) {
                        // Handle the value change
                        if (newValue != null && bmsList.isNotEmpty) {
                          for (var bmsId in newValue.bmsList) {
                            Bms bms = bmsList
                                .firstWhere((element) => element.id == bmsId);
                            selectedBmsList.add(bms);
                          }
                        }
                        setState(() {
                          selectedBatch = newValue;
                        });
                      },
                      labelText: 'Select the Batch',
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: bmsList.length,
                              itemBuilder: (context, index) {
                                Bms bms = bmsList[index];
                                return CheckboxListTile(
                                  title: Text(
                                    bms.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  value: selectedBmsList.contains(bms),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedBmsList.add(bms);
                                      } else {
                                        selectedBmsList.remove(bms);
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor: Colors
                                      .blue, // Change the color to your preference
                                );
                              },
                            ),
                          ),
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
                              masterBloc.add(AddBmsInBatchEvent(
                                  batchData: Batch(
                                      id: selectedBatch!.id,
                                      batchName: selectedBatch!.batchName,
                                      customerId: selectedBatch!.customerId,
                                      bmsList: List.from(
                                          selectedBmsList.map((e) => e.id)))));
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
