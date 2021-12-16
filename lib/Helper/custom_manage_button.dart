import 'package:flutter/material.dart';

class CustomManageButton extends StatelessWidget {
  const CustomManageButton({
    Key key,
    this.icon,
    this.title,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
