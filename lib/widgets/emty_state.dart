import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {Key? key, required this.message, this.callToaction, required this.image})
      : super(key: key);
  final String message;
  final Widget? callToaction;
  final Widget image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image,
            const SizedBox(
              height: 12,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            if (callToaction != null) callToaction!
          ],
        ),
      ),
    );
  }
}
