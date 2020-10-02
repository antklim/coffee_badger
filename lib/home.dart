import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Center(
            child: Text('Coffee Badger'),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
