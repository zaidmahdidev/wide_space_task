import 'package:flutter/material.dart';

class MessageDisplayWidget extends StatelessWidget {
  const MessageDisplayWidget({required this.message, Key? key})
      : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: Text('Error'),
          ),
        ),
      ),
    ]);
  }
}
