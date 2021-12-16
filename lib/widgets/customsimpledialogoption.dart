import 'package:flutter/material.dart';

class CustomSimpleDialogOption extends StatelessWidget {
  const CustomSimpleDialogOption({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 2,
          color: Colors.blueGrey[50],
        ),
      ],
    );
  }
}
