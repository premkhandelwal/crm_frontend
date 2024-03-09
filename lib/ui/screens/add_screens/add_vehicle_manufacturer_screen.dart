// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_vehicle_manufacturer_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];

class AddVehicleManufacturerScreen extends StatefulWidget {
  final bool isEdit;
  final VehicleManufacturer? editVehicleManufacturer;
  final bool returnData;
  const AddVehicleManufacturerScreen(
      {Key? key,
      this.isEdit = false,
      this.editVehicleManufacturer,
      this.returnData = false})
      : super(key: key);

  @override
  State<AddVehicleManufacturerScreen> createState() =>
      _AddVehicleManufacturerScreenState();
}

class _AddVehicleManufacturerScreenState
    extends State<AddVehicleManufacturerScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleManufacturerNameCtrller =
      TextEditingController();

  late MasterBloc masterBloc;

  Customer? selectedCustomer;

  @override
  void initState() {
    if (widget.isEdit) {
      vehicleManufacturerNameCtrller.text =
          widget.editVehicleManufacturer!.name;
    }
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchCustomerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Vehicle Manufacturer"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(customerState.customerList);
            if (widget.isEdit || widget.editVehicleManufacturer != null) {
              int ind = customerList.indexWhere((element) =>
                  element.id == widget.editVehicleManufacturer!.customerId);
              if(ind != -1){
              selectedCustomer = customerList[ind];

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
                          selectedCustomer = newValue;
                        });
                      },
                      labelText: 'Select the Customer',
                    ),
                    const SizedBox(height: 10),
                    buildTextFormFieldWithIcon(
                      controller: vehicleManufacturerNameCtrller,
                      labelText: 'Vehicle Manufacturer Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<MasterBloc, MasterState>(
                      listener: (context, state) {
                        if (state is AddVehicleManufacturerState ||
                            state is EditVehicleManufacturerState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            if (widget.returnData) {
                              state as AddVehicleManufacturerState;
                              Navigator.pop(context, state.vehicleManufacturer);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Vehicle Manufacturer ${widget.isEdit ? 'edited' : 'added'} successfully")));
                              context.read<AppCubit>().appPageChaged(
                                  const ViewVehicleManufacturerScreen());
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
                        if ((state is AddVehicleManufacturerState ||
                                state is EditVehicleManufacturerState) &&
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
                              VehicleManufacturer vmData = VehicleManufacturer(
                                name: vehicleManufacturerNameCtrller.text,
                                customerId: selectedCustomer!.id,
                              );
                              if (widget.isEdit) {
                                vmData = vmData.copyWith(
                                    id: widget.editVehicleManufacturer!.id);

                                masterBloc.add(EditVehicleManufacturerEvent(
                                    vehicleManufacturerData: vmData));
                              } else {
                                masterBloc.add(AddVehicleManufacturerEvent(
                                    vehicleManufacturerData: vmData));
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
