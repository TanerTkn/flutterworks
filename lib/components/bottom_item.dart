import 'package:flutter/material.dart';
import 'package:todolist/constants/color_constants.dart';

class BottomItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final Function onTap;

  const BottomItem({Key key, this.text, this.icon, this.isSelected, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // highlightColor: ColorConstants.instance.primary,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: isSelected ? ColorConstants.instance.orangePeel : Colors.grey, size: 22),
          SizedBox(height: 3),
          Text(text,
              style: TextStyle(color: isSelected ? ColorConstants.instance.orangePeel : Colors.grey, fontWeight: FontWeight.bold, fontSize: 14))
        ]),
      ),
    );
  }
}
