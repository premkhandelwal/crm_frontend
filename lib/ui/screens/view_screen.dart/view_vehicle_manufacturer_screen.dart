import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/ui/screens/add_screens/add_vehicle_manufacturer_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<VehicleManufacturer> vehicleManufacturerList = [];
List<Customer> customerList = [];

class ViewVehicleManufacturerScreen extends StatefulWidget {
  const ViewVehicleManufacturerScreen({super.key});

  @override
  State<ViewVehicleManufacturerScreen> createState() =>
      _ViewVehicleManufacturerScreenState();
}

class _ViewVehicleManufacturerScreenState
    extends State<ViewVehicleManufacturerScreen> {
  late AppCubit appCubit;

  Customer? selectedCustomer;

  @override
  void initState() {
    appCubit = BlocProvider.of<AppCubit>(context);
    context.read<MasterBloc>().add(FetchCustomerEvent());
    context.read<MasterBloc>().add(FetchAllVehicleManufacturerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Vehicle Manufacturer"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is FetchAllVehicleManufacturerState &&
              state.submissionStatus == SubmissionStatus.success) {
            vehicleManufacturerList = List.from(state.vehicleManufacturerList);
          } else if (state is FetchCustomerState &&
              state.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(state.customerList);
          } else if (state is DeleteVehicleManufacturerState &&
              state.submissionStatus == SubmissionStatus.success) {
            vehicleManufacturerList.remove(state.deletedVehicleManufacturer);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted vehicle manufacturer successfully")));
          }
        },
        builder: (context, state) {
          return BlocConsumer<MasterBloc, MasterState>(
            listener: (context, state) {
              if (state is FetchVehicleForCustomerState &&
                  state.submissionStatus == SubmissionStatus.success) {
                vehicleManufacturerList =
                    List.from(state.vehicleManufacturerList);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  buildDropdownFormFieldWithIcon<Customer?>(
                    items: customerList,
                    value: selectedCustomer,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.read<MasterBloc>().add(
                            FetchVehicleForCustomerEvent(
                                customerId: newValue.id));
                      }

                      setState(() {
                        selectedCustomer = newValue;
                      });
                    },
                    labelText: 'Select the Customer',
                  ),
                  selectedCustomer != null
                      ? _buildVehicleManufacturerListView(
                          vehicleManufacturerList)
                      : Container()
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appCubit.appPageChaged(const AddVehicleManufacturerScreen());
        },
        tooltip: "Add New Vehicle Manufacturer",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildVehicleManufacturerListView(
      List<VehicleManufacturer> vehicleManufacturerList) {
    return ListView(
      shrinkWrap: true,
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Edit')),
            DataColumn(label: Text('Delete')),
          ],
          rows: vehicleManufacturerList.map((vM) {
            return DataRow(
              cells: [
                DataCell(Text(vM.name)),
                DataCell(IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    appCubit.appPageChaged(AddVehicleManufacturerScreen(
                      isEdit: true,
                      editVehicleManufacturer: vM,
                    ));
                  },
                )),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<MasterBloc>().add(
                        DeleteVehicleManufacturerEvent(
                            vehicleManufacturerData: vM));
                  },
                )),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
