import 'package:animated_drop_down/animated_drop_down_item.dart';
import 'package:flutter/material.dart';

class AnimatedDropDownItemWidget extends StatelessWidget {
  const AnimatedDropDownItemWidget({
    Key? key,
    required this.onTap,
    required this.title,
    this.subTitle,
    required this.leading,
    this.isSelected = false,
    required this.height,
  }) : super(key: key);

  final void Function(AnimatedDropDownItems item) onTap;
  final String title;
  final String? subTitle;
  final Widget leading;
  final bool isSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(AnimatedDropDownItems(
          title: title,
          leading: leading,
          isSelected: isSelected,
          subTitle: subTitle,
        ));
      },
      child: Container(
        color: Colors.transparent,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leading,
            const SizedBox(width: 20),
            Text(title),
            const Spacer(),
            Text(subTitle ?? ''),
            const Spacer(),
            isSelected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                : const Icon(Icons.radio_button_unchecked_outlined)
          ],
        ),
      ),
    );
  }
}
