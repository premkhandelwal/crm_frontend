import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/ui/screens/add_screens/add_harness_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Harness> harnessList = [];

class ViewHarnessScreen extends StatefulWidget {
  const ViewHarnessScreen({super.key});

  @override
  State<ViewHarnessScreen> createState() => _ViewHarnessScreenState();
}

class _ViewHarnessScreenState extends State<ViewHarnessScreen> {
  late AppCubit appCubit;
  @override
  void initState() {
    appCubit = context.read<AppCubit>();
    context.read<MasterBloc>().add(FetchHarnessEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Harness"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, harnessState) {
          if (harnessState is FetchHarnessState &&
              harnessState.submissionStatus == SubmissionStatus.success) {
            harnessList = List.from(harnessState.harnessList);
          } else if (harnessState is DeleteHarnessState &&
              harnessState.submissionStatus == SubmissionStatus.success) {
            harnessList.remove(harnessState.deletedHarness);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted harness successfully")));
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
                  rows: harnessList.map((harness) {
                    return DataRow(
                      cells: [
                        DataCell(Text(harness.name)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            appCubit.appPageChaged(AddHarnessScreen(
                              isEdit: true,
                              editHarnessData: harness,
                            ));
                          },
                        )),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<MasterBloc>()
                                .add(DeleteHarnessEvent(harnessData: harness));
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
          context.read<AppCubit>().appPageChaged(const AddHarnessScreen());
        },
        tooltip: "Add New Harness",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
