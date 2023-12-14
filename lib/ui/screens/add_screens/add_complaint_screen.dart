import 'package:crm/logic/blocs/complaint/complaint_bloc.dart';
import 'package:crm/enums.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({Key? key}) : super(key: key);

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController bmsClientNameController = TextEditingController();
  TextEditingController bmsNameController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  TextEditingController batchNoController = TextEditingController();
  TextEditingController harnessDetailsController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();

  late ComplaintBloc complaintBloc;

  @override
  void initState() {
    complaintBloc = BlocProvider.of<ComplaintBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Complaint"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildTextFormFieldWithIcon(
                  controller: bmsClientNameController,
                  labelText: 'BMS Client Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: bmsNameController,
                  labelText: 'BMS Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: returnDateController,
                  labelText: 'Return Date',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: complaintController,
                  labelText: 'Complaint',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: batchNoController,
                  labelText: 'Batch No',
                  icon: Icons.confirmation_number,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: harnessDetailsController,
                  labelText: 'Harness Details',
                  icon: Icons.details,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: makeController,
                  labelText: 'Make',
                  icon: Icons.build,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: customerIdController,
                  labelText: 'Customer ID',
                  icon: Icons.person_pin,
                ),
                const SizedBox(height: 20),
                BlocConsumer<ComplaintBloc, ComplaintState>(
                  listener: (context, state) {
                    if (state is ComplaintSubmitState) {
                      if (state.submissionStatus == SubmissionStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Complaint added successfully")));
                        
                      } else if (state.submissionStatus ==
                          SubmissionStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Failed to lodge complaint")));
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is ComplaintSubmitState &&
                        state.submissionStatus == SubmissionStatus.inProgress) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          // Access the form field values using the controllers
                          Complaint complaintData = Complaint(
                            bmsClientName: bmsClientNameController.text,
                            bmsName: bmsNameController.text,
                            returnDate:
                                DateTime.parse(returnDateController.text),
                            complaint: complaintController.text,
                            batchNo: batchNoController.text,
                            harnessDetails: [harnessDetailsController.text],
                            make: makeController.text,
                            customerId: customerIdController.text,
                          );
                          complaintBloc.add(ComplaintSubmitButtonPressed(
                              complaintData: complaintData));
                        }
                      },
                      child: const Text('Submit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
}
