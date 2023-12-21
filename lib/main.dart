import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/app/app_cubit.dart';
import 'package:crm/logic/cubits/bmsValue/bms_value_cubit.dart';
import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/navigation/route_registry.dart';
import 'package:crm/providers/api_provider.dart';
import 'package:crm/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => BmsValueCubit(),
        ),
        BlocProvider(
          create: (context) => ComplaintCubit(),
        ),
        BlocProvider(
          create: (context) => InfoBloc(ApiProvider()),
        ),
        BlocProvider(
          create: (context) => MasterBloc(ApiProvider()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        routes: routesMap,
        home: const HomeScreen(),
      ),
    );
  }
}
