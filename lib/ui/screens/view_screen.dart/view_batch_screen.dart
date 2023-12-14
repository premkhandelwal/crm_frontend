import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/batch_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Batch> batchs = [];

class ViewBatchScreen extends StatefulWidget {
  const ViewBatchScreen({super.key});

  @override
  State<ViewBatchScreen> createState() => _ViewBatchScreenState();
}

class _ViewBatchScreenState extends State<ViewBatchScreen> {
  @override
  void initState() {
    context.read<CustomerBloc>().add(FetchBatchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Batch"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, batchState) {
          if (batchState is FetchBatchState &&
              batchState.submissionStatus == SubmissionStatus.success) {
            batchs = List.from(batchState.batchList);
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
                  rows: batchs.map((batch) {
                    return DataRow(
                      cells: [
                        DataCell(Text(batch.batchName)),
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
