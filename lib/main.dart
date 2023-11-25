import 'package:crm/blocs/complaint/complaint_bloc.dart';
import 'package:crm/home_screen.dart';
import 'package:crm/navigation/route_registry.dart';
import 'package:crm/providers/api_provider.dart';
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
          create: (context) => ComplaintBloc(ApiProvider()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: routesMap,
        home: const HomeScreen(),
      ),
    );
  }
}
