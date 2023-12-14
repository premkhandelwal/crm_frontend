import 'package:crm/models/complaint_request.dart';
import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const CustomerDetailsScreen({Key? key, required this.complaint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer: ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              "Contact: ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            // Add more customer details as needed...
          ],
        ),
      ),
    );
  }
}
