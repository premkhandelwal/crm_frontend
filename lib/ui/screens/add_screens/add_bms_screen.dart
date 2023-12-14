import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/bms_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBmsScreen extends StatefulWidget {
  const AddBmsScreen({Key? key}) : super(key: key);

  @override
  State<AddBmsScreen> createState() => _AddBmsScreenState();
}

class _AddBmsScreenState extends State<AddBmsScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController bmsNameController = TextEditingController();
  TextEditingController bmsDescriptionController = TextEditingController();

  late CustomerBloc customerBloc;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bms"),
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
                  controller: bmsNameController,
                  labelText: 'Bms Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                buildTextFormFieldWithIcon(
                  controller: bmsDescriptionController,
                  labelText: 'Bms Description',
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                BlocConsumer<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is AddBmsState) {
                      if (state.submissionStatus == SubmissionStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Bms added successfully")));
                      } else if (state.submissionStatus ==
                          SubmissionStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to add bms")));
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is AddBmsState &&
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
                          Bms bmsData = Bms(
                              name: bmsNameController.text,
                              details: bmsDescriptionController.text);
                          customerBloc.add(AddBmsEvent(bmsData: bmsData));
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
