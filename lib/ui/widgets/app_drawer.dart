import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/ui/screens/add_screens/add_bms_in_batch_screen.dart';
import 'package:crm/ui/screens/add_screens/add_complaint_screen.dart';
import 'package:crm/ui/screens/dashboard_screen.dart';
import 'package:crm/ui/screens/view_screen.dart/view_batch_screen.dart';
import 'package:crm/ui/screens/view_screen.dart/view_bms_screen.dart';
import 'package:crm/ui/screens/view_screen.dart/view_customer_screen.dart';
import 'package:crm/ui/screens/view_screen.dart/view_harness_screen.dart';
import 'package:crm/ui/screens/view_screen.dart/view_make_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return drawer();
  }

  Widget drawer() {
    return Drawer(
      width: 300, // Increased width for more navigation options
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            // Using UserAccountsDrawerHeader for convenience
            currentAccountPicture: avatar(),
            accountName: accountName(),
            accountEmail: null,
          ),
          const Divider(),
          ...generateDrawerItems(), // Replace with your navigation items
        ],
      ),
    );
  }

  List<Widget> generateDrawerItems() {
    AppCubit appCubit = BlocProvider.of<AppCubit>(context);
    return [
      ListTile(
        leading: Icon(Icons.dashboard, color: Theme.of(context).primaryColor),
        title: const Text("Dashboard"),
        onTap: () {
          appCubit.appPageChaged(const DashBoardScreen());
        },
      ),
      ExpansionTile(
        leading: Icon(Icons.remove_red_eye_outlined,
            color: Theme.of(context).primaryColor),
        title: const Text("Masters"),
        expandedCrossAxisAlignment: CrossAxisAlignment.end,
        expandedAlignment: Alignment.bottomRight,
        collapsedBackgroundColor: Theme.of(context).indicatorColor,
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
            title: const Text("Customer"),
            onTap: () {
              appCubit.appPageChaged(const ViewCustomerScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_copy_outlined,
                color: Theme.of(context).primaryColor),
            title: const Text("Batch"),
            onTap: () {
              appCubit.appPageChaged(const ViewBatchScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.person_3_outlined,
                color: Theme.of(context).primaryColor),
            title: const Text("Make"),
            onTap: () {
              appCubit.appPageChaged(const ViewMakeScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.details, color: Theme.of(context).primaryColor),
            title: const Text("Harness"),
            onTap: () {
              appCubit.appPageChaged(const ViewHarnessScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.devices, color: Theme.of(context).primaryColor),
            title: const Text("BMS"),
            onTap: () {
              appCubit.appPageChaged(const ViewBmsScreen());
            },
          ),
        ],
      ),
      ListTile(
        leading: Icon(Icons.circle, color: Theme.of(context).primaryColor),
        title: const Text("Add BMS in Batch"),
        onTap: () {
          appCubit.appPageChaged(const AddBmsInBatchScreen());
        },
      ),
      ListTile(
        leading: Icon(Icons.circle, color: Theme.of(context).primaryColor),
        title: const Text("Add Complaint"),
        onTap: () {
          appCubit.appPageChaged(const AddComplaintScreen());
        },
      ),
    ];
  }

  Widget avatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: Icon(Icons.person, color: Theme.of(context).primaryColor),
    );
  }

  Widget accountName() {
    return Text(
      "CRM-U",
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
