import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/ui/screens/add_screens/add_batch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Batch> batchList = [];

class ViewBatchScreen extends StatefulWidget {
  const ViewBatchScreen({super.key});

  @override
  State<ViewBatchScreen> createState() => _ViewBatchScreenState();
}

class _ViewBatchScreenState extends State<ViewBatchScreen> {
  late AppCubit appCubit;

  @override
  void initState() {
    appCubit = BlocProvider.of<AppCubit>(context);
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
        listener: (context, batchState) {
          if (batchState is FetchBatchState &&
              batchState.submissionStatus == SubmissionStatus.success) {
            batchList = List.from(batchState.batchList);
          } else if (batchState is DeleteBatchState &&
              batchState.submissionStatus == SubmissionStatus.success) {
            batchList.remove(batchState.deletedBatch);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted batch successfully")));
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
              ),
            ],
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
}
