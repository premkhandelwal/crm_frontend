import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customers = [];
List<Bms> bmsList = [];

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late MasterBloc masterBloc;
  late InfoBloc infoBloc;

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    infoBloc = BlocProvider.of<InfoBloc>(context);
    masterBloc.add(FetchCustomerEvent());
    masterBloc.add(FetchBmsEvent());

    super.initState();
  }

  Customer? selectedCustomer;

  List<Batch> batchListForCustomer = [];
  Batch? selectedBatchForCustomer;
  List<Bms> bmsListForSelectedBatch = [];
  Bms? selectedBms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customers = List.from(customerState.customerList);
          }
        },
        builder: (context, customerState) {
          // Your existing UI code...
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.inProgress) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Center(child: Text("Fetching customers"))
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedCustomer != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (selectedBms != null) {
                                    selectedBms = null;
                                  } else if (selectedBatchForCustomer != null) {
                                    selectedBatchForCustomer = null;
                                  } else {
                                    selectedCustomer = null;
                                  }
                                });
                              },
                              child: const Text("Go back")),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                Center(
                  child: Text(
                    selectedCustomer == null
                        ? "Select the customer:"
                        : selectedBatchForCustomer == null
                            ? "Select the batch:"
                            : selectedBms == null
                                ? "Select the bms:"
                                : "Fill the details:",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedCustomer == null
                        ? BlocConsumer<MasterBloc, MasterState>(
                            listener: (context, state) {
                              if (state is FetchCustomerState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                customers = List.from(state.customerList);
                              } else if (state is FetchBmsState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                bmsList = List.from(state.bmsList);
                              }
                            },
                            builder: (context, state) {
                              return buildCustomerWidget();
                            },
                          )
                        : BlocConsumer<InfoBloc, InfoState>(
                            listener: (context, state) {
                              if (state is FetchBatchForCustomerState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                batchListForCustomer =
                                    List.from(state.batchList);
                              }
                            },
                            builder: (context, state) {
                              return selectedBatchForCustomer == null
                                  ? _buildBatchListView()
                                  : selectedBms == null
                                      ? _buildBmsListView(
                                          bmsListForSelectedBatch)
                                      : Container();
                            },
                          ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCustomerWidget() {
    return ListView.builder(
      shrinkWrap: true,
      // Your existing builder code...
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customers[index].name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        infoBloc.add(FetchBatchForCustomerEvent(
                            customerId: customers[index].id));
                        setState(() {
                          selectedCustomer = customers[index];
                        });
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text("View Details"),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBatchListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: batchListForCustomer.length,
      itemBuilder: (context, index) {
        Batch batch = batchListForCustomer[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedBatchForCustomer = batch;
                bmsListForSelectedBatch = [];
                for (var bmsId in batch.bmsList) {
                  bmsListForSelectedBatch.add(
                      bmsList.firstWhere((element) => element.id == bmsId));
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 10.0),
                        Text(
                          batch.batchName,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBmsListView(List<Bms> bmsList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bmsList.length,
      itemBuilder: (context, index) {
        Bms bms = bmsList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedBms = bms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 10.0),
                        Text(
                          bms.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
