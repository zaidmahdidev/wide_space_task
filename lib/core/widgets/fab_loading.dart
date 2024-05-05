import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FABLoading extends StatefulWidget {
  final VoidCallback onPressed;
  final bool value;
  final IconData icon;

  const FABLoading({
    Key? key,
    required this.onPressed,
    required this.value,
    this.icon = Icons.done,
  }) : super(key: key);

  @override
  _FABLoadingState createState() => _FABLoadingState();
}

class _FABLoadingState extends State<FABLoading> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: widget.value
          ? const Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 14,
              ),
            )
          : Icon(widget.icon),
      onPressed: widget.value
          ? null
          : () {
              FocusScope.of(context).unfocus();
              widget.onPressed.call();
            },
    );
  }
}
