// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_batch_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];

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

  late MasterBloc masterBloc;

  Customer? selectedCustomer;

  @override
  void initState() {
    if (widget.isEdit) {
      batchNameController.text = widget.editBatch!.batchName;
    }
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchCustomerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Batch"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(customerState.customerList);
            if (widget.isEdit) {
              selectedCustomer = customerList.firstWhere(
                  (element) => element.id == widget.editBatch!.customerId);
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
                    BlocConsumer<MasterBloc, MasterState>(
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
                                customerId: selectedCustomer!.id,
                              );
                              if (widget.isEdit) {
                                batchData = batchData.copyWith(
                                    id: widget.editBatch!.id);

                                masterBloc
                                    .add(EditBatchEvent(batchData: batchData));
                              } else {
                                masterBloc
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
}
