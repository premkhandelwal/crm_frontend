import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildCustomerWidget(List<Customer> customers, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    // Your existing builder code...
    itemCount: customers.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: isDashboard ? null : Colors.white,
        child: InkWell(
          onTap: !isDashboard
              ? () {
                  context
                      .read<ComplaintCubit>()
                      .selectedCustomerChanged(customers[index]);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customers[index].name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                isDashboard
                    ? ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ComplaintCubit>()
                              .selectedCustomerChanged(customers[index]);
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text("View Details"),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBatchListView(List<Batch> batchListForCustomer) {
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
            context.read<ComplaintCubit>().selectedBatchChanged(batch);
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

Widget buildBmsListView(List<MapEntry<Bms, List<String>>> bmsList) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsList.length,
    itemBuilder: (context, index) {
      Bms bms = bmsList[index].key;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context
                .read<ComplaintCubit>()
                .selectedBmsChanged(bms, bmsList[index].value);
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

Widget buildBmsSerialNoListView(List<String> bmsSerialNoList) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsSerialNoList.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context
                .read<ComplaintCubit>()
                .selectedSerialNoChanged(bmsSerialNoList[index]);
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
                        bmsSerialNoList[index],
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

Widget buildComplaintTextFields(
    {required TextEditingController returnDateController,
    required TextEditingController complaintController,
    required TextEditingController observationController,
    required TextEditingController commentController,
    required TextEditingController solutionController,
    required TextEditingController testingDoneByController}) {
  return Column(
    children: [
      buildTextFormFieldWithIcon(
        controller: returnDateController,
        labelText: 'Return Date',
        icon: Icons.calendar_today,
      ),
      buildTextFormFieldWithIcon(
        controller: complaintController,
        labelText: 'Complaint',
        icon: Icons.description,
        maxLines: 3,
      ),
      buildTextFormFieldWithIcon(
        controller: observationController,
        labelText: 'Observation',
        icon: Icons.description,
        maxLines: 3,
      ),
      buildTextFormFieldWithIcon(
        controller: commentController,
        labelText: 'Comment',
        icon: Icons.description,
        maxLines: 3,
      ),
      buildTextFormFieldWithIcon(
        controller: solutionController,
        labelText: 'Solution',
        icon: Icons.description,
        maxLines: 3,
      ),
      buildTextFormFieldWithIcon(
        controller: testingDoneByController,
        labelText: 'Testing Done By',
        icon: Icons.description,
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget buildTextFormFieldWithIcon({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  int maxLines = 1,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10.0),
          prefixIcon: Icon(icon),
        ),
        maxLines: maxLines,
      ),
    ),
  );
}
