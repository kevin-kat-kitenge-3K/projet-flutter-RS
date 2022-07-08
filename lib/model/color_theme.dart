
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ColorTheme {

  //Sans le context
  bool isDarkMode() {
    final window = WidgetsBinding.instance.window;
    final mode = MediaQueryData.fromWindow(window).platformBrightness;
    return (mode == Brightness.dark);
  }

  // Avec le context

  bool isDarkModeWithContext(BuildContext context) {
    final mode = MediaQuery.of(context).platformBrightness;
    return (mode == Brightness.dark);
  }
  Color pointer() => Colors.blue;
  Color base() => (isDarkMode()) ? Colors.black54 : Colors.white;
  Color accent() => (isDarkMode()) ? Colors.grey : Colors.black38;
}

