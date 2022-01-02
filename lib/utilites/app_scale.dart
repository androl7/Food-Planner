import 'package:flutter/widgets.dart';

class AppScale {
  final BuildContext _ctxt;

  AppScale(this._ctxt);

  double get listRowMealsSize => scaledHeight(.05);
  double get listMealsPaddingSize => scaledHeight(.01);
  double get iconSize => scaledHeight(.03);
  double get fontSize => scaledHeight(.02);
  double get spaceBetweenElementsInTheWrap => scaledHeight(.01);

  double scaledWidth(double widthScale) {
    return MediaQuery.of(_ctxt).size.width * widthScale;
  }

  double scaledHeight(double heightScale) {
    return MediaQuery.of(_ctxt).size.height * heightScale;
  }
}