import 'package:crm/blocs/complaint/complaint_bloc.dart';
import 'package:crm/enums.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/navigation/route_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ComplaintBloc complaintBloc;

  @override
  void initState() {
    complaintBloc = BlocProvider.of<ComplaintBloc>(context);
    complaintBloc.add(FetchComplaintsEvent());
    super.initState();
  }

  List<Complaint> complaints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("My CRM App"),
      ),
      body: BlocConsumer<ComplaintBloc, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintFetchState &&
              state.submissionStatus == SubmissionStatus.success) {
            complaints = List.from(state.complaintList);
          }
        },
        builder: (context, state) {
          if (state is ComplaintFetchState &&
              state.submissionStatus == SubmissionStatus.inProgress) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Text("Fetching complaints")
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      complaints[index].complaint,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    // Add more details or actions if needed
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            NavRoutes.addComplaintScreen,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
