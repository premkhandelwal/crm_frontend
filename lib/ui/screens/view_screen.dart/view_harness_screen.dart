import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/harness_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Harness> harnesss = [];

class ViewHarnessScreen extends StatefulWidget {
  const ViewHarnessScreen({super.key});

  @override
  State<ViewHarnessScreen> createState() => _ViewHarnessScreenState();
}

class _ViewHarnessScreenState extends State<ViewHarnessScreen> {
  @override
  void initState() {
    context.read<CustomerBloc>().add(FetchHarnessEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Harness"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, harnessState) {
          if (harnessState is FetchHarnessState &&
              harnessState.submissionStatus == SubmissionStatus.success) {
            harnesss = List.from(harnessState.harnessList);
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
                  rows: harnesss.map((harness) {
                    return DataRow(
                      cells: [
                        DataCell(Text(harness.name)),
                        const DataCell(Icon(Icons.edit)),
                        const DataCell(Icon(Icons.delete)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
