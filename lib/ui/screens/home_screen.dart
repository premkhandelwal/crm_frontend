import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/ui/screens/common_complaint_screen.dart';
import 'package:crm/ui/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import necessary packages and widgets

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDrawer(),
          BlocBuilder<AppCubit, AppState>(
            builder: (context, appState) {
              if (appState is PageChangedState) {
                return Flexible(child: appState.newPage);
              }
              return const Flexible(
                child: CommonComplaintScreen(isDashBoard: true,),
              );
            },
          ),
        ],
      ),
      
    );
  }
}
