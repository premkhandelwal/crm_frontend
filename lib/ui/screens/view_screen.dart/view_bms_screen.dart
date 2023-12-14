import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/bms_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Bms> bmss = [];

class ViewBmsScreen extends StatefulWidget {
  const ViewBmsScreen({super.key});

  @override
  State<ViewBmsScreen> createState() => _ViewBmsScreenState();
}

class _ViewBmsScreenState extends State<ViewBmsScreen> {
  @override
  void initState() {
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
            bmss = List.from(bmsState.bmsList);
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
                  rows: bmss.map((bms) {
                    return DataRow(
                      cells: [
                        DataCell(Text(bms.name)),
                        DataCell(Text(bms.details)),
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
