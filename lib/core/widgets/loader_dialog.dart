import 'package:flutter/material.dart';

class LoaderDialog extends StatelessWidget {
  const LoaderDialog({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: AlertDialog(
          title: Text(title),
          content: const LinearProgressIndicator(),
        ));
  }
}
