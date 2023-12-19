import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/add_screens/add_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];

class ViewCustomerScreen extends StatefulWidget {
  const ViewCustomerScreen({super.key});

  @override
  State<ViewCustomerScreen> createState() => _ViewCustomerScreenState();
}

class _ViewCustomerScreenState extends State<ViewCustomerScreen> {
  late MasterBloc masterBloc;
  late AppCubit appCubit;

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    appCubit = BlocProvider.of<AppCubit>(context);
    masterBloc.add(FetchCustomerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Customers"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(customerState.customerList);
          } else if (customerState is DeleteCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList.remove(customerState.deletedCustomer);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted customer successfully")));
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              IntrinsicHeight(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Edit')),
                    DataColumn(label: Text('Delete')),
                  ],
                  rows: customerList.map((customer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(customer.name)),
                        DataCell(IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              appCubit.appPageChaged(AddCustomerScreen(
                                isEdit: true,
                                editCustomerData: customer,
                              ));
                            })),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            masterBloc.add(
                                DeleteCustomerEvent(customerData: customer));
                          },
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appCubit.appPageChaged(const AddCustomerScreen());
        },
        tooltip: "Add New Customer",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
