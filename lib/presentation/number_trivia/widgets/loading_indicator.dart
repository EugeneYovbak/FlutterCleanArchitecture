import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
