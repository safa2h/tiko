import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorWidgetCustom extends StatelessWidget {
  const ErrorWidgetCustom({
    Key? key,
    required this.errorMessage,
    required this.tapCallback,
  }) : super(key: key);

  final String errorMessage;
  final GestureTapCallback tapCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 18, color: Colors.red.shade700),
          ),
          const SizedBox(
            height: 8,
          ),
          Lottie.asset('assets/animation/error_anim.json', width: 200),
          ElevatedButton(
              onPressed: tapCallback,
              child: Text(
                'try again',
                style: Theme.of(context).textTheme.bodyMedium,
              ))
        ],
      ),
    );
  }
}
