import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/customer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late CustomerBloc customerBloc;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    customerBloc.add(FetchCustomerEvent());
    super.initState();
  }

  List<Customer> customers = [];

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      // Add your date formatting logic here
      return "${date.day}/${date.month}/${date.year}";
    }

    void viewDetails(Customer customer) {}

    void editCustomer(Customer customer) {
      // Handle editing customer
    }

    return BlocConsumer<CustomerBloc, CustomerState>(
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
          child: ListView.builder(
            // Your existing builder code...
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
                              viewDetails(customers[index]);
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text("View Details"),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              editCustomer(customers[index]);
                            },
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
          ),
        );
      },
    );
  }
}
