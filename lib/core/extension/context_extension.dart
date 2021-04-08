import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext {
  double dynamicHeight(double value) => MediaQuery.of(this).size.height * value;
  double dynamicWidth(double value) => MediaQuery.of(this).size.width * value;
  double dynamicWidthB(double value) => MediaQuery.of(this).size.width / value;
}
