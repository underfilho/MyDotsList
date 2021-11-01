import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mydotslist/dot.dart';
import 'dart:async';

import 'package:mydotslist/my_popup.dart';

class DotsList extends StatefulWidget {
  final List<Dot> dots;
  final Function(int) onSelected;
  final int selected;
  final Color colorSelected;

  DotsList({
    @required this.dots,
    this.onSelected,
    this.colorSelected,
    this.selected = 0,
  });

  @override
  _DotsListState createState() => _DotsListState();
}

class _DotsListState extends State<DotsList>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  CurvedAnimation _curve;
  Timer _timerReverse;
  OverlayEntry _overlayEntry;
  List<GlobalKey> _keys;
  int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    _animController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _curve = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _timerReverse =
            Timer(Duration(seconds: 1), () => _animController.reverse());
    });

    _keys =
        widget.dots.mapIndexed((i, e) => LabeledGlobalKey('dot$i')).toList();
  }

  @override
  void dispose() {
    closePopUp();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.dots.mapIndexed((i, dot) {
        return Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (i == selected)
                showPopUp();
              else {
                setState(() => selected = i);
                showPopUp();
                if (widget.onSelected != null) widget.onSelected(i);
              }
            },
            child: Container(
              key: _keys[i],
              height: 30,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: (i == selected)
                      ? (widget.colorSelected == null)
                          ? dot.color
                          : widget.colorSelected
                      : Colors.transparent,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: dot.color,
                  shape: BoxShape.circle,
                ),
                child: dot.child,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void showPopUp() {
    _animController.reset();
    closePopUp();

    _overlayEntry = _overlayEntryBuilder();
    _animController.forward();
    Overlay.of(context).insert(_overlayEntry);
  }

  void closePopUp() {
    if (_timerReverse != null) if (_timerReverse.isActive)
      _timerReverse.cancel();

    if (isPopupOpen()) _overlayEntry.remove();
  }

  bool isPopupOpen() {
    if (_overlayEntry == null) return false;
    return _overlayEntry.mounted;
  }

  OverlayEntry _overlayEntryBuilder() {
    RenderBox renderBox = _keys[selected].currentContext.findRenderObject();
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);
    double width = 150;
    double xcoord = 0.5;

    return OverlayEntry(builder: (context) {
      var screenWidth = MediaQuery.of(context).size.width;
      if (position.dx < 100) xcoord = 0.3;
      if (position.dx + size.width > screenWidth - 100) xcoord = 0.7;

      return Positioned(
        top: position.dy + size.height - 5.0,
        left:
            ((0.5 - xcoord) * width) + position.dx - width / 2 + size.width / 2,
        width: width,
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            alignment: Alignment((xcoord - 0.5) * 2, -1),
            scale: _curve,
            child: MyPopUp(
              xcoord: xcoord,
              color: widget.dots[selected].color,
              text: widget.dots[selected].name,
            ),
          ),
        ),
      );
    });
  }
}
