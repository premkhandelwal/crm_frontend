import 'package:flutter/material.dart';
import 'screen_argument.dart';

mixin NavigableScreen<T extends ScreenArguments> {
  T getArgument(BuildContext context) {
    Object? arg = ModalRoute.of(context)!.settings.arguments;
    if (arg == null || arg is! T) {
      throw Exception("argument is not type of $T and it is of type $arg");
    }
    return arg;
  }
}
