
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final snap;
  final VoidCallback tab;
  const CustomListTile({
    Key? key,
    required this.tab,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tab,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            snap['userProfile'],
          ),
        ),
        title: Text(snap['userName']),
      ),
    );
  }
}