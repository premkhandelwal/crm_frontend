import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomerScreen extends StatefulWidget {
  final bool isEdit;
  final Customer? editCustomerData;
  const AddCustomerScreen(
      {Key? key, this.isEdit = false, this.editCustomerData})
      : super(key: key);

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController customerNameController = TextEditingController();

  late CustomerBloc customerBloc;

  @override
  void initState() {
    if (widget.isEdit) {
      customerNameController.text = widget.editCustomerData!.name;
    }
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Customer"),
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
                  controller: customerNameController,
                  labelText: 'Customer Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                BlocConsumer<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is AddCustomerState ||
                        state is EditCustomerState) {
                      if (state.submissionStatus == SubmissionStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Customer ${widget.isEdit ? 'edited' : 'added'} successfully")));
                        context
                            .read<AppCubit>()
                            .appPageChaged(const ViewCustomerScreen());
                      } else if (state.submissionStatus ==
                          SubmissionStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Failed to ${widget.isEdit ? 'edit' : 'add'} customer")));
                      }
                    }
                  },
                  builder: (context, state) {
                    if ((state is AddCustomerState ||
                            state is EditCustomerState) &&
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
                          Customer customerData = Customer(
                            name: customerNameController.text,
                          );
                          if (widget.isEdit) {
                            customerData.id = widget.editCustomerData!.id;
                            customerBloc.add(EditCustomerEvent(
                              customerData: customerData,
                            ));
                          } else {
                            customerBloc.add(
                                AddCustomerEvent(customerData: customerData));
                          }
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
