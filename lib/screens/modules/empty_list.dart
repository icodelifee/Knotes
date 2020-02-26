import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: true,
      fillOverscroll: false,
      child: Text(
        "Empty",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
