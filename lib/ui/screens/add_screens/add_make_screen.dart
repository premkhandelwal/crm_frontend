import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/ui/screens/view_screen.dart/view_make_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMakeScreen extends StatefulWidget {
  final bool isEdit;
  final Make? editMakeData;
  const AddMakeScreen({Key? key, this.isEdit = false, this.editMakeData})
      : super(key: key);

  @override
  State<AddMakeScreen> createState() => _AddMakeScreenState();
}

class _AddMakeScreenState extends State<AddMakeScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController makeNameController = TextEditingController();

  late MasterBloc masterBloc;

  @override
  void initState() {
    if (widget.isEdit) {
      makeNameController.text = widget.editMakeData!.name;
    }
    masterBloc = BlocProvider.of<MasterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? 'Edit' : 'Add'} Make"),
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
                  controller: makeNameController,
                  labelText: 'Make Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                BlocConsumer<MasterBloc, MasterState>(
                  listener: (context, state) {
                    if (state is AddMakeState || state is EditMakeState) {
                      if (state.submissionStatus == SubmissionStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Make ${widget.isEdit ? 'edited' : 'added'} successfully")));
                        context
                            .read<AppCubit>()
                            .appPageChaged(const ViewMakeScreen());
                      } else if (state.submissionStatus ==
                          SubmissionStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Failed to ${widget.isEdit ? 'edit' : 'add'} make")));
                      }
                    }
                  },
                  builder: (context, state) {
                    if ((state is AddMakeState || state is EditMakeState) &&
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
                          Make makeData = Make(name: makeNameController.text);
                          if (widget.isEdit) {
                            makeData =
                                makeData.copyWith(id: widget.editMakeData!.id);
                            masterBloc.add(EditMakeEvent(
                              makeData: makeData,
                            ));
                          } else {
                            masterBloc.add(AddMakeEvent(makeData: makeData));
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
