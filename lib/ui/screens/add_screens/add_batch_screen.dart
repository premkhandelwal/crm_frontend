// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_batch_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];
List<VehicleManufacturer> vehicleManufacturerList = [];

class AddBatchScreen extends StatefulWidget {
  final bool isEdit;
  final Batch? editBatch;
  final bool returnData;
  const AddBatchScreen(
      {Key? key, this.isEdit = false, this.editBatch, this.returnData = false})
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
  VehicleManufacturer? selectedVehicleManufacturer;

  @override
  void initState() {
    if (widget.isEdit) {
      batchNameController.text = widget.editBatch!.batchName;
    }
    if (widget.editBatch != null) {}
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
            if (widget.isEdit || widget.editBatch != null) {
              int ind = customerList.indexWhere(
                  (element) => element.id == widget.editBatch!.customerId);
              if (ind != -1) {
                selectedCustomer = customerList[ind];
              }
              masterBloc.add(FetchVehicleForCustomerEvent(
                  customerId: selectedCustomer!.id));
            }
          } else if (customerState is FetchVehicleForCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            vehicleManufacturerList =
                List.from(customerState.vehicleManufacturerList);
            if (widget.editBatch != null) {
              int ind = vehicleManufacturerList.indexWhere((element) =>
                  element.id == widget.editBatch?.vehicleManufacturerId);
              if (ind != -1) {
                selectedVehicleManufacturer = vehicleManufacturerList[ind];
              }
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
                    buildDropdownFormFieldWithIcon<Customer?>(
                      items: customerList,
                      value: selectedCustomer,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          vehicleManufacturerList = [];
                          selectedVehicleManufacturer = null;
                          selectedCustomer = newValue;
                          if (selectedCustomer != null) {
                            masterBloc.add(FetchVehicleForCustomerEvent(
                                customerId: selectedCustomer!.id));
                          }
                        });
                      },
                      labelText: 'Select the Customer',
                    ),
                    const SizedBox(height: 10),
                    buildDropdownFormFieldWithIcon<VehicleManufacturer?>(
                      items: vehicleManufacturerList,
                      value: selectedVehicleManufacturer,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedVehicleManufacturer = newValue;
                        });
                      },
                      labelText: 'Select the Vehicle Manufacturer',
                    ),
                    const SizedBox(height: 10),
                    buildTextFormFieldWithIcon(
                      controller: batchNameController,
                      labelText: 'Batch Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<MasterBloc, MasterState>(
                      listener: (context, state) {
                        if (state is AddBatchState || state is EditBatchState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            if (widget.returnData) {
                              state as AddBatchState;
                              Navigator.pop(context, state.batch);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Batch ${widget.isEdit ? 'edited' : 'added'} successfully")));
                              context
                                  .read<AppCubit>()
                                  .appPageChaged(const ViewBatchScreen());
                            }
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
                          onPressed: selectedCustomer != null &&
                                  selectedVehicleManufacturer != null
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle form submission
                                    // Access the form field values using the controllers
                                    Batch batchData = Batch(
                                        batchName: batchNameController.text,
                                        customerId: selectedCustomer!.id,
                                        vehicleManufacturerId:
                                            selectedVehicleManufacturer!.id);
                                    if (widget.isEdit) {
                                      batchData = batchData.copyWith(
                                          id: widget.editBatch!.id);

                                      masterBloc.add(
                                          EditBatchEvent(batchData: batchData));
                                    } else {
                                      masterBloc.add(
                                          AddBatchEvent(batchData: batchData));
                                    }
                                  }
                                }
                              : null,
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
