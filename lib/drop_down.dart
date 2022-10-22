import 'dart:math';

import 'package:animated_drop_down/animated_drop_down_item.dart';
import 'package:animated_drop_down/animated_drop_down_item_widget.dart';
import 'package:flutter/material.dart';

class AnimatedDropDown extends StatefulWidget {
  const AnimatedDropDown(
      {Key? key,
      this.borderRadius,
      this.tileColor,
      this.expandedTileColor,
      this.height,
      this.width,
      required this.items,
      this.initialItem,
      this.trailingText})
      : super(key: key);

  final double? borderRadius;
  final Color? tileColor;
  final Color? expandedTileColor;
  final Text? trailingText;
  final double? width;
  final double? height;
  final List<AnimatedDropDownItems> items;
  final AnimatedDropDownItems? initialItem;

  @override
  State<AnimatedDropDown> createState() => _AnimatedDropDownState();
}

class _AnimatedDropDownState extends State<AnimatedDropDown>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;
  late final GlobalKey dropDownKey;
  final Duration _animDuration = const Duration(milliseconds: 300);
  double? height, width, xPosition, yPosition;
  late final AnimationController _animationController;
  late final AnimationController _secondaryAnimController;
  late Animation<double> _containerAnim;
  late Animation<double> _arrowAnim;
  late Animation<double> _fadeAnim;
  late ValueNotifier<AnimatedDropDownItems> _currentItem;

  @override
  void initState() {
    dropDownKey = LabeledGlobalKey("dropDown");
    _currentItem = ValueNotifier(widget.items[0]);
    _animationController = AnimationController(
        vsync: this, duration: _animDuration, reverseDuration: _animDuration);
    _secondaryAnimController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200));
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(_secondaryAnimController);
    _containerAnim =
        Tween<double>(begin: 0, end: 0).animate(_animationController);
    _arrowAnim = Tween<double>(begin: 0, end: pi).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _secondaryAnimController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTileTap,
        child: Container(
          key: dropDownKey,
          width: widget.width,
          height: widget.height ?? 72,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 2), blurRadius: 10),
              ],
              color: widget.tileColor ?? Colors.white),
          child: ValueListenableBuilder<AnimatedDropDownItems>(
            valueListenable: _currentItem,
            builder: (context, value, child) => Row(
              children: [
                if (widget.initialItem != null) widget.initialItem!.leading,
                if (widget.initialItem == null) value.leading,
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.initialItem != null
                        ? widget.initialItem!.title
                        : value.title),
                    Text(widget.initialItem != null
                        ? widget.initialItem!.subTitle ?? ''
                        : value.subTitle ?? "")
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.trailingText != null) widget.trailingText!,
                    AnimatedBuilder(
                      animation: _arrowAnim,
                      builder: (context, child) => Transform.rotate(
                        angle: _arrowAnim.value,
                        child: child,
                      ),
                      child: const Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 42,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _onTileTap() {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _overlayEntry = _createDropDown();
      Overlay.of(context)!.insert(_overlayEntry!);
      _animationController.forward();
    } else {
      _secondaryAnimController.reverse().then((_) {
        _animationController.reverse().then((_) {
          _overlayEntry?.remove();
        });
      });
    }
  }

  OverlayEntry _createDropDown() {
    final RenderBox renderBox =
        dropDownKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    height = renderBox.size.height;
    width = renderBox.size.width;
    xPosition = offset.dx;
    yPosition = offset.dy;

    if (_isExpanded) {
      _containerAnim =
          Tween<double>(begin: 0, end: height! * widget.items.length)
              .animate(_animationController);
    }

    return OverlayEntry(builder: (context) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTapDown: (TapDownDetails detail) {
                _secondaryAnimController.reverse().then((_) {
                  _animationController.reverse().then((_) {
                    _overlayEntry?.remove();
                  });
                });
                _isExpanded = !_isExpanded;
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _containerAnim,
            builder: (context, child) {
              return Positioned(
                left: xPosition,
                width: width,
                top: yPosition! + height!,
                height: _containerAnim.value,
                child: child!,
              );
            },
            child: Material(
              color: Colors.transparent,
              elevation: 5,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.expandedTileColor ?? Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius ?? 0))),
                child: AnimatedBuilder(
                  animation: _secondaryAnimController,
                  builder: (context, child) =>
                      FadeTransition(opacity: _fadeAnim, child: child!),
                  child: ValueListenableBuilder<AnimatedDropDownItems>(
                    valueListenable: _currentItem,
                    builder: (context, value, child) => Column(
                      children: widget.items
                          .map((element) => AnimatedDropDownItemWidget(
                                height: height!,
                                title: element.title,
                                subTitle: element.subTitle,
                                leading: element.leading,
                                isSelected: element.title == value.title,
                                onTap: (item) {
                                  _currentItem.value = item;
                                  _secondaryAnimController.reverse().then((_) {
                                    _animationController.reverse().then((_) {
                                      _overlayEntry?.remove();
                                    });
                                  });
                                  _isExpanded = !_isExpanded;
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
