import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Empty List");
    return SliverFillRemaining(
      child: Container(
        width: 300.0,
        height: 300.0,
        color: Colors.red,
      ),
    );
  }
}
