import 'package:crm/add_complaint_screen.dart';
import 'package:crm/home_screen.dart';
import 'package:flutter/widgets.dart';

class NavRoutes {
  static const String homeScreen = "/homeScreen";
  static const String addComplaintScreen = "/addComplaintScreen";
}

final Map<String, WidgetBuilder> routesMap = {
  NavRoutes.addComplaintScreen: (context) => const AddComplaintScreen(),
  NavRoutes.homeScreen: (context) => const HomeScreen(),
};
