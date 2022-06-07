import 'dart:ui' show Color;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xcell/theme/colors.dart';

Image appLogo = new Image(
    image: new AssetImage("assets/title.jpg"),
    fit: BoxFit.contain,
    );

// Background
Color background = Color(0xFF444444);
Color groupItemInput = Color(0xff444444);
Color cardBack = Color(0xff606060);
Color cardDropDown = Color(0xff7a7a7a);
Color drawerBackground = Color(0xffaaaaaa);
Color dayBackSelected = Color(0xff606060);
Color dayBackNotSelected = Color(0xffaaaaaa);
Color featureColor = Color(0xfff4eb49);
Color topLeftDif = Color(0xff606060);
Color botRightDif = Color(0xff444444);
Color userMessage = Color(0xff444444);
Color groupDivider = Color(0xff7a7a7a);
Color setButton = Color(0xff5e5e5e);
Color linkedAccountBackground = Color(0xff606060);

// Text
Color drawerText = Color(0xff232323);
Color cardDropText = Color(0xffd6d6d6);
Color groupCardTitle = Color(0xffd6d6d6);
Color cardText = Color(0xffd2d2d2);
Color loggingItemName = Color(0xffc0c0c0);
Color dayTextNotSelected = Color(0xff444444);
Color dayTextSelected = Color(0xfff4eb49);
Color cardFeatureText = Color(0xfff4eb49);
Color hintMessage = Color(0xff717171);
Color difficulty = Color(0xffc6c6c6);

// Icons
Color cardIcon = Color(0xffc0c0c0);
Color cardAddIcon = Color(0xfff4eb49);
Color completedLogging = Color(0xff539749);


Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
}
