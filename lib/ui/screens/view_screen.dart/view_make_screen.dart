import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/ui/screens/add_screens/add_make_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Make> makeList = [];

class ViewMakeScreen extends StatefulWidget {
  const ViewMakeScreen({super.key});

  @override
  State<ViewMakeScreen> createState() => _ViewMakeScreenState();
}

class _ViewMakeScreenState extends State<ViewMakeScreen> {
  late AppCubit appCubit;
  @override
  void initState() {
    appCubit = context.read<AppCubit>();
    context.read<MasterBloc>().add(FetchMakeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Make"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, makeState) {
          if (makeState is FetchMakeState &&
              makeState.submissionStatus == SubmissionStatus.success) {
            makeList = List.from(makeState.makeList);
          } else if (makeState is DeleteMakeState &&
              makeState.submissionStatus == SubmissionStatus.success) {
            makeList.remove(makeState.deletedMake);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted make successfully")));
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
                  rows: makeList.map((make) {
                    return DataRow(
                      cells: [
                        DataCell(Text(make.name)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            appCubit.appPageChaged(AddMakeScreen(
                              isEdit: true,
                              editMakeData: make,
                            ));
                          },
                        )),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<MasterBloc>()
                                .add(DeleteMakeEvent(makeData: make));
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
          context.read<AppCubit>().appPageChaged(const AddMakeScreen());
        },
        tooltip: "Add New Make",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
