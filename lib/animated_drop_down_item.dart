import 'package:flutter/material.dart';

class AnimatedDropDownItems {
  const AnimatedDropDownItems({
    required this.title,
    this.subTitle,
    this.isSelected = false,
    required this.leading,
  });

  final String title;
  final String? subTitle;
  final Widget leading;
  final bool isSelected;
}
