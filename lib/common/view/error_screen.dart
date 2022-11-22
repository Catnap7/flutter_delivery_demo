import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({
    required this.error,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(error),
          ElevatedButton(onPressed: (){
            context.go('/');
          }, child: Text('홈으로'),),
        ],
      ),
    );
  }
}
