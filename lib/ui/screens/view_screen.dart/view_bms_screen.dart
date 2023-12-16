import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/ui/screens/add_screens/add_bms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Bms> bmsList = [];

class ViewBmsScreen extends StatefulWidget {
  const ViewBmsScreen({super.key});

  @override
  State<ViewBmsScreen> createState() => _ViewBmsScreenState();
}

class _ViewBmsScreenState extends State<ViewBmsScreen> {
  late AppCubit appCubit;
  @override
  void initState() {
    appCubit = context.read<AppCubit>();
    context.read<CustomerBloc>().add(FetchBmsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Bms"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, bmsState) {
          if (bmsState is FetchBmsState &&
              bmsState.submissionStatus == SubmissionStatus.success) {
            bmsList = List.from(bmsState.bmsList);
          } else if (bmsState is DeleteBmsState &&
              bmsState.submissionStatus == SubmissionStatus.success) {
            bmsList.remove(bmsState.deletedBms);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted bms successfully")));
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              IntrinsicHeight(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Details')),
                    DataColumn(label: Text('Edit')),
                    DataColumn(label: Text('Delete')),
                  ],
                  rows: bmsList.map((bms) {
                    return DataRow(
                      cells: [
                        DataCell(Text(bms.name)),
                        DataCell(Text(bms.details)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            appCubit.appPageChaged(AddBmsScreen(
                              isEdit: true,
                              editBmsData: bms,
                            ));
                          },
                        )),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<CustomerBloc>()
                                .add(DeleteBmsEvent(bmsData: bms));
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
          appCubit.appPageChaged(const AddBmsScreen());
        },
        tooltip: "Add New Bms",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
