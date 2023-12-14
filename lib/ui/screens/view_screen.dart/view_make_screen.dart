import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/make_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Make> makes = [];

class ViewMakeScreen extends StatefulWidget {
  const ViewMakeScreen({super.key});

  @override
  State<ViewMakeScreen> createState() => _ViewMakeScreenState();
}

class _ViewMakeScreenState extends State<ViewMakeScreen> {
  @override
  void initState() {
    context.read<CustomerBloc>().add(FetchMakeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Make"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, makeState) {
          if (makeState is FetchMakeState &&
              makeState.submissionStatus == SubmissionStatus.success) {
            makes = List.from(makeState.makeList);
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
                  rows: makes.map((make) {
                    return DataRow(
                      cells: [
                        DataCell(Text(make.name)),
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
