import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/add_screens/add_batch_screen.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Batch> batchList = [];
List<Customer> customerList = [];

class ViewBatchScreen extends StatefulWidget {
  const ViewBatchScreen({super.key});

  @override
  State<ViewBatchScreen> createState() => _ViewBatchScreenState();
}

class _ViewBatchScreenState extends State<ViewBatchScreen> {
  late AppCubit appCubit;

  Customer? selectedCustomer;

  @override
  void initState() {
    appCubit = BlocProvider.of<AppCubit>(context);
    context.read<MasterBloc>().add(FetchCustomerEvent());
    context.read<MasterBloc>().add(FetchBatchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Batch"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is FetchBatchState &&
              state.submissionStatus == SubmissionStatus.success) {
            batchList = List.from(state.batchList);
          } else if (state is FetchCustomerState &&
              state.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(state.customerList);
          } else if (state is DeleteBatchState &&
              state.submissionStatus == SubmissionStatus.success) {
            batchList.remove(state.deletedBatch);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted batch successfully")));
          }
        },
        builder: (context, state) {
          return BlocConsumer<MasterBloc, MasterState>(
            listener: (context, state) {
              if (state is FetchBatchForCustomerState &&
                  state.submissionStatus == SubmissionStatus.success) {
                batchList = List.from(state.batchList);
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
                            FetchBatchForCustomerEvent(
                                customerId: newValue.id));
                      }
              
                      setState(() {
                        selectedCustomer = newValue;
                      });
                    },
                    labelText: 'Select the Customer',
                  ),
                  selectedCustomer != null
                      ? _buildBatchListView(batchList)
                      : Container()
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appCubit.appPageChaged(const AddBatchScreen());
        },
        tooltip: "Add New Batch",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildBatchListView(List<Batch> batchList) {
    return ListView(
      shrinkWrap: true,
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Edit')),
            DataColumn(label: Text('Delete')),
          ],
          rows: batchList.map((batch) {
            return DataRow(
              cells: [
                DataCell(Text(batch.batchName)),
                DataCell(IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    appCubit.appPageChaged(AddBatchScreen(
                      isEdit: true,
                      editBatch: batch,
                    ));
                  },
                )),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<MasterBloc>()
                        .add(DeleteBatchEvent(batchData: batch));
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
