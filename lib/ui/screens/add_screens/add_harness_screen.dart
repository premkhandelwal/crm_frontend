import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_harness_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddHarnessScreen extends StatefulWidget {
  final bool isEdit;
  final Harness? editHarnessData;
  const AddHarnessScreen({Key? key, this.isEdit = false, this.editHarnessData})
      : super(key: key);

  @override
  State<AddHarnessScreen> createState() => _AddHarnessScreenState();
}

class _AddHarnessScreenState extends State<AddHarnessScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController harnessNameController = TextEditingController();

  late MasterBloc masterBloc;

  @override
  void initState() {
    if (widget.isEdit) {
      harnessNameController.text = widget.editHarnessData!.name;
    }
    masterBloc = BlocProvider.of<MasterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Harness"),
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
                  controller: harnessNameController,
                  labelText: 'Harness Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                BlocConsumer<MasterBloc, MasterState>(
                  listener: (context, state) {
                    if (state is AddHarnessState || state is EditHarnessState) {
                      if (state.submissionStatus == SubmissionStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Harness ${widget.isEdit ? 'edited' : 'added'} successfully")));
                        context
                            .read<AppCubit>()
                            .appPageChaged(const ViewHarnessScreen());
                      } else if (state.submissionStatus ==
                          SubmissionStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Failed to ${widget.isEdit ? 'edit' : 'add'} harness")));
                      }
                    }
                  },
                  builder: (context, state) {
                    if ((state is AddHarnessState ||
                            state is EditHarnessState) &&
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
                          Harness harnessData =
                              Harness(name: harnessNameController.text);
                          if (widget.isEdit) {
                            harnessData = harnessData.copyWith(
                                id: widget.editHarnessData!.id);
                            masterBloc.add(EditHarnessEvent(
                              harnessData: harnessData,
                            ));
                          } else {
                            masterBloc
                                .add(AddHarnessEvent(harnessData: harnessData));
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
